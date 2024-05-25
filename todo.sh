
#!/bin/bash

if [ $1 == "help" ];
then 
echo "create : To Create a task "
echo "update : To Update a task "
echo "delete : To Delete a task "
echo "show : To Show all information about a task "
echo "list : To List tasks of a given day in two output sections: completed and uncompleted "
echo "search : To Search for a task by title "


elif [ $1 == "create" ];
then
echo "To create a task you should enter this informations: "
read -p "Enter the identifier of your task : " id
read -p "Enter the title of your task : " title
while [ -z "$title" ]; do
echo "The title cannot be empty"
read -p "Enter the title of your task : " title
done
read -p "Enter a description of your task : " description
read -p "Enter a location for your task : " location
read -p "Enter a due date and time for your task : " due_date
while [ -z "$due_date" ]; do
echo "The due date cannot be empty"
read -p "Enter a due date and time for your task : " due_date
done
read -p "Enter a completion marker for your task : " completion_marker
fichier="Tasks.txt"
echo "Id: $id" >> "$fichier"
echo "Title: $title" >> "$fichier"
echo "Description: $description" >> "$fichier"
echo "Location: $location" >> "$fichier"
echo "Due Date: $due_date" >> "$fichier"
echo "Completion marker: $completion_marker" >> "$fichier"
echo "////////////////////////////////////////"

elif [ $1 == "update" ];
then 
echo "Here are the tasks that you have created: "
while read Ligne; do
echo "$Ligne"
done < Tasks.txt
read -p "Enter the id of the task that you want to modify : " id_mod
ids=$(grep -o 'Id: [0-9]*' Tasks.txt | cut -d' ' -f2)
id_found=0
for id in $ids; do
    if [ "$id_mod" == "$id" ]; then
         id_found=1
         break
    fi
done
if [ $id_found -eq 1 ]; then
    echo "ID found."
        echo "What do you want to modify?"
        echo "1. ID"
        echo "2. Title"
        echo "3. Description"
        echo "4. Location"
        echo "5. Due Date"
        echo "6. Completion marker"
        read -p "Enter the number of your choice: " choice
           
        case $choice in
		1) 
			read -p "Enter new ID: " new_value
			sed -i "/^Id: $id_mod$/,/^Completion marker:/ s/^Id: .*/Id: $new_value/" Tasks.txt
                ;;
		2) 
			read -p "Enter new Title: " new_value
			sed -i "/^Id: $id_mod$/,/^Completion marker:/ s/^Title: .*/Title: $new_value/" Tasks.txt
                ;;
		3) 
			read -p "Enter new Description: " new_value
			sed -i "/^Id: $id_mod$/,/^Completion marker:/ s/^Description: .*/Description: $new_value/" Tasks.txt
                ;;
		4)
			read -p "Enter new Location: " new_value
			sed -i "/^Id: $id_mod$/,/^Completion marker:/ s/^Location: .*/Location: $new_value/" Tasks.txt
                ;;
		5) 
			read -p "Enter new Due Date: " new_value
			sed -i "/^Id: $id_mod$/,/^Completion marker:/ s/^Due Date: .*/Due Date: $new_value/" Tasks.txt
                ;;
		6) 
			read -p "Enter new Completion marker: " new_value
			sed -i "/^Id: $id_mod$/,/^Completion marker:/ s/^Completion marker: .*/Completion marker: $new_value/" Tasks.txt
                ;;
		*)
			echo "Invalid choice."
	esac

else
    echo "ID not found. Please enter a valid ID."

fi

elif [ $1 == "delete" ];
then
echo "Here are the tasks that you have created: "
while read Ligne; do
echo "$Ligne"
done < Tasks.txt
read -p "Can you write the id of the task that you want to delete : " id_del
ids=$(grep -o 'Id: [0-9]*' Tasks.txt | cut -d' ' -f2)
id_found=0
for id in $ids; do
    if [ "$id_del" == "$id" ]; then
         id_found=1
         break
    fi
done
if [ $id_found -eq 1 ]; then
	echo "ID found."
	sed -i "/^Id: $id_del$/,/^Completion marker:/d" Tasks.txt
        echo "Task with ID $id_del has been deleted."
else
        echo "ID not found. Please enter a valid ID."
fi


elif [ $1 == "show" ];
then 
read -p "Can you write the id of the task that you want to see : " id_sh
id_found=0
current_task=""
	while IFS= read -r line; do
        	if [[ $line == "Id: $id_sh" ]]; then
            		id_found=1
            		current_task="$line"
        	elif [[ $id_found -eq 1 && $line == Id:* ]]; then
            		id_found=2
        	fi

        if [[ $id_found -eq 1 ]]; then
        	current_task="$current_task"$'\n'"$line"
        fi
    	done < Tasks.txt

    	if [[ $id_found -eq 1 || $id_found -eq 2 ]]; then
        	echo "Details of the task with ID $id_sh:"
        	echo "$current_task"
    	else
        	echo "ID not found. Please enter a valid ID."
    	fi

elif [ $1 == "list" ];
then 
	read -p "Enter the date (format YYYY-MM-DD) to list tasks: " target_date

    completed_tasks=()
    uncompleted_tasks=()
    current_task=""
    add_to_list=0
    task_date=""
    completion_marker=""

    while IFS= read -r line; do
        if [[ $line == Id:* ]]; then
            if [[ $task_date == $target_date ]]; then
                if [[ $completion_marker == "Completion marker: yes" ]]; then
                    completed_tasks+=("$current_task")
                else
                    uncompleted_tasks+=("$current_task")
                fi
            fi
            current_task="$line"
            add_to_list=0
        else
            current_task="$current_task"$'\n'"$line"
        fi

        if [[ $line == Due\ Date:* ]]; then
            task_date=$(echo $line | cut -d' ' -f3)
        fi

        if [[ $line == Completion\ marker:* ]]; then
            completion_marker="$line"
            add_to_list=1
        fi

    done < Tasks.txt

    if [[ $task_date == $target_date ]]; then
        if [[ $completion_marker == "Completion marker: yes" ]]; then
            completed_tasks+=("$current_task")
        else
            uncompleted_tasks+=("$current_task")
        fi
    fi

    echo "Tasks for date: $target_date"
    echo "Completed Tasks:"
    if [ ${#completed_tasks[@]} -eq 0 ]; then
        echo "No completed tasks found."
    else
        for task in "${completed_tasks[@]}"; do
            echo "$task"
            echo
        done
    fi

    echo "Uncompleted Tasks:"
    if [ ${#uncompleted_tasks[@]} -eq 0 ]; then
        echo "No uncompleted tasks found."
    else
        for task in "${uncompleted_tasks[@]}"; do
            echo "$task"
            echo
        done
    fi

elif [ $1 == "search" ];
then
    read -p "Can you write the title of the task that you want to see : " title_sh
    found_tasks=()
    current_task=""
    add_to_task=0

    while IFS= read -r line; do
        if [[ $line == Id:* ]]; then
            if [ $add_to_task -eq 1 ]; then
                found_tasks+=("$current_task")
            fi
            current_task="$line"
            add_to_task=0
        else
            current_task="$current_task"$'\n'"$line"
        fi

        if [[ $line == Title:\ $title_sh ]]; then
            add_to_task=1
        fi

    done < Tasks.txt

    if [ $add_to_task -eq 1 ]; then
        found_tasks+=("$current_task")
    fi

    if [ ${#found_tasks[@]} -eq 0 ]; then
        echo "No tasks found with the title '$title_sh'."
    else
        echo "Tasks with the title '$title_sh':"
        for task in "${found_tasks[@]}"; do
            echo "$task"
            echo
        done
    fi

else 
    echo "If you don't know what to write you can write 'help' to get some help.. :)"
fi
