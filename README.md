
# News and gaming forum website

Website which combines a typical news website and a forum website into 1. Users can catch up on the latest news and discuss various topics with other users.

The project fixes some of the most crucial problems of modern news websites and forum websites. Most news websites don't allow for discussions between users, and if they do it's only in the comment section of an article. 
Forums are a great place for discussions on various topics and allow for users to freely express their thoughts on various issues. Users can create posts on any topic, including news, but since posts can by made by any user the information isn't all that trustworthy, so it's hard to get the actual news from forums.
So, to fix these problems this project combines the functionalities of the two websites into one, to make it easy for users to find trustworthy news and to discuss news or other topics with others.
  

How setup the enviornment for the project:
-
1. Search 'Windows features on or off' with windows key + s
2. In the menu turn on 'Windows Subsystem for Linux', 'Virtual Machine Platform' and 'Windows Hyperviser Platform', press "OK" to apply changes and restart your computer
3. Now open the Microsoft Store app in your computer
4. In the store search for 'Ubuntu' and download the latest LTS version
5. In the store search for Windows terminal and download the first option and open the terminal
6. In the terminal open a window for Ubuntu, if WSL requires an update run this command in the CMD
    ```
    wsl.exe --update
    ```
7. In the Ubuntu window run the following commands:
   1. Update your package list
      ```
      sudo apt update
      ```
   2. Install the dependencies required to install Ruby
   ```
   sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
   ```
   3. Use curl to fetch the install script from Github and pipe it directly to bash to run the installer
      ```
      curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
      ```
   5. Next, add ~/.rbenv/bin to your $PATH so that you can use the rbenv command line utility
      ```
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
      ```
   7. Add the command eval "$(rbenv init -)" to your ~/.bashrc file so rbenv loads automatically
      ```
      echo 'eval "$(rbenv init -)"' >> ~/.bashrc
      ```
   9. Apply the changes you made to your ~/.bashrc file to your current shell session
       ```
       source ~/.bashrc
      ```
   11. Verify that rbenv is set up properly
       ```
       type rbenv
       ```
       The output should be :
       ```
       rbenv is a function
       rbenv ()
       {
           local command;
           command="${1:-}";
           if [ "$#" -gt 0 ]; then
               shift;
           fi;
           case "$command" in
               rehash | shell)
                   eval "$(rbenv "sh-$command" "$@")"
               ;;
               *)
                   command rbenv "$command" "$@"
               ;;
           esac
       }
        ```

8. Install ruby, for this project you'll need ruby 3.0.3
    ```
   rbenv install 3.0.3
   ```
9. After the installation is done set ruby 3.0.3 as the default version
    ```
    rbenv global 3.0.3
    ```


10. Make sure that ruby has been succesfully downloaded
    ```
    ruby -v 
    ```
11. Install rails, this command will download the latest version
    ```
    gem install rails
    ```
12. Install SQLite3
    ```
    sudo apt install libsqlite3-dev
    ```

13. Download [Git](https://gitforwindows.org)
14. Install Node.js in the ubuntu terminal with the command
    ```
    sudo apt install nodejs
    ```
15. Download and setup [VS Code](https://code.visualstudio.com)

Thats it for the enviornment setup!

How to launch the project:
-
1. Create a new directory for the project with ubuntu by opening the ubuntu terminal with the previously dowloaded Terminal app by running the following command:
   ```
   mkdir directory_name
   ```
2. Download the zip file from github
3. Unzip the file and move it to your newly created ubuntu directory
4. In the ubuntu terminal navigate to the project folder (cd dir_name -> cd project)
5.  From the project folder run the following command:
    ```
    bundle install
    ```
6. From the project folder run the following command:
    ```
    rails db:migrate
    ```
7. From the project folder run the following command: 
    ```
    rails s
    ```
8. By running the previous command it should show a link to the local host of the project, ctrl rick click the link to open the project in your browser
9. To open the project in your code editor you can type the following command from the project folder
    ```
    code .
    ```
That's it! Now the project should be running as intended!

  
# Functionality 
Functions without Log-in include:
- 
- Main page, which displays newly created articles and posts with recent activity;
- Browsing posts and articles;
- Searching for specific articles and posts;
- Log-in and Sign-up.
  
Functions unlocked on Log-in include:
- 
   - Post creation;
   - Ability to create Comments on Posts and Articles.
  
Functions for admin:
-
  - Delete Articles, Posts, Comments and Replies, deleting a post or article will also delete all related comments and replies;
  - Edit and update Articles and posts;
  - Article creation.

# Competitors 
1. Reddit - 
Way too broad, hard for different game communities to communicate.
Forums made by the games publisher, ex. eu.forums.blizzard.com - way too specific, limiting forum to discussions related only about the publishers games limits the users to only players of said games.
2. Dexerto -
News sites that cover gaming news, like Dexerto, discussions are very limited or non-existent, discussion happen only in comments under articles, limiting community growth or longer discussions, because users don't return to a specifc article that many times.


## Used technoligies

- SQLite3
- Ruby On Rails
- Bootstrap
- HTML/CSS/JavaScript/Ruby



