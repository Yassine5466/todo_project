# ToDo Shell Script

## Project Description
This project is a simple ToDo application implemented as a shell script. The script allows users to create, update, delete, list, show, and search tasks stored in a text file (`Tasks.txt`).

## Design Choices
### Data Storage
- **Tasks.txt**: Tasks are stored in a plain text file with each task consisting of multiple fields:
  - `Id`: Unique identifier for the task.
  - `Title`: The title of the task.
  - `Description`: A brief description of the task.
  - `Location`: The location where the task is to be performed.
  - `Due Date`: The due date of the task.
  - `Completion marker`: Marks the task as completed or uncompleted.

### Code Organization
- **todo.sh**: The main script containing all the functionalities.
- **Tasks.txt**: A file that stores the tasks.

## How to Run the Program
1. **Clone the repository**:
    ```sh
    git clone https://github.com/Yassine5466/todo_project
    ```

2. **Make the script executable**:
    ```sh
    chmod +x todo.sh
    ```

3. **Run the script with the desired command**:
    ```sh
    ./todo.sh <command>
    ```

## Commands
- `help`: Display help information about available commands.
- `create`: Add a new task.
- `update`: Update an existing task.
- `delete`: Delete a task.
- `show`: Show details of a specific task.
- `list`: List tasks of a given day, separated into completed and uncompleted.
- `search`: Search for tasks by title.

## Examples
### Displaying Help Information
./todo.sh help
