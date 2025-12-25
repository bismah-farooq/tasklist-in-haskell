-- Name: Bismah Farooq 
-- Date: 11/17/2025
-- Program description: This is a haskel program, this programs asks the users if they want to complter certain tasks. 
-- those tasks are then being displayed to the user and then user will choose from the option 1-5. if the user choose the option 1 it will ask to add a new task
-- which a user wants to get done. Similarly user can also remove a task if the task is done or is not required anymore. 

import Data.List
import Data.List.Split (splitOn)

-- Date Record.
data Date = Date { year :: Int, month :: Int, day :: Int }
    deriving (Eq, Ord)

-- Task Record.
data Task = Task { date :: Date, desc :: String }
    deriving (Eq, Ord)

-- Date implementing Show.
instance Show Date where
    show (Date y m d) = show m ++ "/" ++ show d ++ "/" ++ show y

-- Task implementing Show.
instance Show Task where
    show (Task d s) = s ++ " - Due: " ++ show d

-- Reads tasks from a file and returns a list of Task objects.
loadTasksFromFile :: FilePath -> IO [Task]
loadTasksFromFile filepath = do
    contents <- readFile filepath
    let linesOfFile = lines contents
    let tasks = map parseTask linesOfFile
    return (sort tasks)

-- Parses and converts a string task into a Task object.
parseTask :: String -> Task
parseTask line =
    let [desc, monStr, dayStr, yearStr] = splitOn "," line
        mon  = read monStr
        day  = read dayStr
        year = read yearStr
    in Task (Date year mon day) desc

-- Adds a task object to the tasklist.
addTask :: Task -> [Task] -> [Task]
addTask t ts = sort (t : ts)

-- Removes the current task from the tasklist.
removeTask :: [Task] -> [Task]
removeTask []     = []
removeTask (_:xs) = xs

-- Postpones a task by one day.
postpone :: Task -> Task
postpone (Task (Date y m d) s) = Task (Date y m (d + 1)) s

-- Postpones all tasks by one day.
postponeAll :: [Task] -> [Task]
postponeAll = map postpone

-- Enumerates the list of tasks and returns a list of strings.
enumerateTasks :: [Task] -> [String]
enumerateTasks [] = ["No tasks."]
enumerateTasks ts = zipWith (\i t -> show i ++ ". " ++ show t) [1..] ts

-- Displays a list of strings.
displayList :: [String] -> IO()
displayList = mapM_ putStrLn

-- Displays a list of enumerated tasks.
displayTasks :: [Task] -> IO()
displayTasks = displayList . enumerateTasks

-- Searches the tasklist for tasks that match the inputted date, returns a list of all matches.
findMatchingDate :: Date -> [Task] -> [Task]
findMatchingDate d = filter (\(Task td _) -> td == d)

-- Displays prompt, gets user input, checks that it is in specified range. Repeats until valid.
validateInput :: String -> Int -> Int -> IO Int
validateInput prompt minval maxval = do
    putStrLn prompt
    value <- getLine
    let intVal = read value :: Int
    if intVal >= minval && intVal <= maxval
        then return intVal
        else do
            putStrLn ("Invalid input - please enter a value " ++ show minval ++ "-" ++ show maxval)
            validateInput prompt minval maxval

-- Prompts the user for their menu selection and executes it.
menu :: [Task] -> IO()
menu tasks = do
    putStrLn "\nTasklist Menu:"
    putStrLn "1. View all tasks"
    putStrLn "2. View all on date"
    putStrLn "3. Add new task"
    putStrLn "4. Remove current task"
    putStrLn "5. Postpone all tasks"
    putStrLn "6. Quit"
    choice <- validateInput "Enter choice:" 1 6
    case choice of
        1 -> do
            putStrLn "Tasks:"
            displayTasks tasks
            menu tasks
        2 -> do
            putStrLn "Enter search date:"
            m <- validateInput "Enter month:" 1 12
            d <- validateInput "Enter day:" 1 31
            y <- validateInput "Enter year:" 2000 2100
            let matches = findMatchingDate (Date y m d) tasks
            displayTasks matches
            menu tasks
        3 -> do
            putStrLn "Enter new task name:"
            name <- getLine
            m <- validateInput "Enter new task month:" 1 12
            d <- validateInput "Enter new task day:" 1 31
            y <- validateInput "Enter new task year:" 2000 2100
            let newList = addTask (Task (Date y m d) name) tasks
            menu newList
        4 -> do
            let newList = removeTask tasks
            menu newList
        5 -> do
            let newList = postponeAll tasks
            menu newList
        6 -> putStrLn "Quitting program..."
        _ -> do
            putStrLn "Invalid option."
            menu tasks

main :: IO ()
main = do
    tasklist <- loadTasksFromFile "tasklist.txt"
    menu tasklist
