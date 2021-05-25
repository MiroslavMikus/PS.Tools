git log --format=fuller

# remove backup references
git update-ref -d refs/original/refs/heads/master

# update commit author and date
git filter-branch -f --env-filter  `
    'if [ $GIT_COMMIT = 4c85eaefa32fb23bac96df942eecd1756f018524 ]
     then
         export GIT_AUTHOR_EMAIL="miroslav.mikus@outlook.com";
         export GIT_COMMITTER_EMAIL="miroslav.mikus@outlook.com";
         export GIT_AUTHOR_DATE="2019-12-10T19:31:47";
         export GIT_COMMITTER_DATE="2019-12-10T19:31:47";
     fi'


git filter-branch -f --env-filter `
    'if [ $GIT_COMMIT = fd81a170b5033f31eb5ec264f1a99707f421aa7c ]
     then
         
         export GIT_AUTHOR_EMAIL="miroslav.mikus@outlook.com";
         export GIT_AUTHOR_DATE="2019-09-21T09:51:07";
         
         export GIT_COMMITTER_EMAIL="miroslav.mikus@outlook.com";
         export GIT_COMMITTER_DATE="2019-09-21T09:51:07";
     fi';


Start-Process "git" -ArgumentList "filter-branch -f --env-filter $command"

# update author name and email
git filter-branch --commit-filter '
        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
        then
                GIT_AUTHOR_NAME="Miroslav Mikus";
                GIT_AUTHOR_EMAIL="miroslav.mikus@outlook.com";
                GIT_COMMITTER_NAME="Miroslav Mikus";
                GIT_COMMITTER_EMAIL="miroslav.mikus@outlook.com"
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD