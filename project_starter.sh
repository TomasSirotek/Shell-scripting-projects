#!/bin/sh

template_path="/Users/Tomas/Projects/projectScript/templates"

validateEmpty(){
    if [ -z "$1" ];
      then
        echo "Nothing inputed. Please write a valid option name."
        continue
    fi
}

validateExistence(){
  if [ -d "$1" ];
      then
        echo "Directory $1 already exists";
        exit 0;
    fi
}

relocatedToDir(){
    cd /Users/Tomas/Projects/testingScriptProjects 
}

createRootFolder(){
    mkdir $1
    cd $1
}

permit(){
    chmod -R 775 .*  
}

saveMode(){
    idea.sh --line project-settings:use-safe-write 
}


PS3="Select desired language of your choice : "
select lang in "C++" "Java" "C#" "quit"
do
   case $lang in
      "C++")
        relocatedToDir
        read -p "What is the name for the project?" name  # ask for dir name
      
        validateEmpty $name # validates   
        validateExistence $name

        createRootFolder $name # creates root folder
        
        cp -r $template_path/c++/ ./
        
        find . -type f -exec perl -pi -e "s/%PROJECT_NAME%/$name/g" {} + # renames all in files 
          
        echo "Opening new project from template in Clion .." 
        saveMode
        clion .  # open in CLION
        break 
      ;;
      "Java")
          PS3="Select the type of Java project: "
          select type in "Spring" "Maven" "Java" 
          do
            case $type in
              "Spring")
                echo "Not implemeted yet"
                break;
                ;;
              "Maven")
                echo "Not implemeted yet"
                break;
                ;;
              "Java")
                relocatedToDir 
               
                read -p "What is the name for the project?" name
                validateEmpty "$name"
                validateExistence "$name"

                createRootFolder $name
                cp -r $template_path/java/javaBasic/ ./
                
                echo "Opening new project from template in IntelliJ ...."

                saveMode
                idea . # open in IDEA
                break
                ;;            
              *) 
              echo "Invalid option $REPLY";;
          esac
        done
       break
      ;;
      "C#")
          relocatedToDir 

          read -p "What is the name for the project?" name 
  
          validateEmpty $name
          validateExistence $name

          createRootFolder $name

          cp -r $template_path/cSharp/ ./
      
          find . -name '*%PROJECT_NAME%*' -depth -execdir rename "s/%PROJECT_NAME%/$name/g" '{}' \; # renames all dir
          find . -type f -exec perl -pi -e "s/%PROJECT_NAME%/$name/g" {} + # renames all in files 

          permit 
          echo "Opening new project from template in Rider ...."
          saveMode
          rider .
          break 
      ;;
      "quit")
        echo "Quitting script ..."
        break
        ;;
      *)
        echo "Invalid option $REPLY"
        ;;
  esac
done


