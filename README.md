# git-autoupdate-linux-script
# What is the purpose of this project
In my job, I usually needed to update my branch with the current updated one. This is the script that I created to optimize this work.

In the beginning it was just an alias for
```bash
git checkout develop
git pull
git checkout branch_im_working_on
git merge
```

But then I started to make some more cool stuff, so I decided to put it here in order to
1. Don't lose this script that I was working on with so much effort
2. Share it with someone who finds its useful.

The main functions alias are references for Jojo's Bizarre Adventure's manga: Steel Ball Run. It was an internal joke about the series so please, don't take it too seriously. 

# How does it works?
Now, I use 3 functions for three different branchs, since I had the need to use more than one source update branch. **I'm working to fix this tho!**

Basically, you can:
- Just type the main function on your terminal and it will go to the `source_branch`, make an pull from that branch, go back to the previosly branch you was working on and executes a `git merge`command. Don't worry, it will not forces the merge, so it won't make anything wrong unless you allow it.
- Type the main function + a new branch name. The script will detect that this branch doesn't exists and will ask you if you want to create a new branch. When you accept, it will create a new branch from `source_branch`


# How to install & use
1. Open your `.bashrc` file (or `.zshrc` file)
```bash
    $ code ~/.bashrc
```

2. Copy and paste this code inside of it.

3. Update your terminal
```bash
    $ source ~/.bashrc
```

4. Open a terminal in the branch you want to update. Type
- `d4c` to update your branch with the develop branch
- `lovetrain` to update your branch with the main branch

# Tips
You can customize this code as much as your needs ask. Change the `target_branch` variable on the main function you want to update. 

If you feel so, change the name of the functions as well 😀

I hope that this helps you and your team development as it helped me!
