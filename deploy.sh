#!/bin/bash

# Check if an argument (develop or main) is provided
if [ -z "$1" ]; then
    echo "Usage: ./deploy.sh {develop|main}"
    exit 1
fi

BRANCH=$1

# Ensure the branch exists
git fetch
if ! git show-ref --quiet refs/heads/$BRANCH; then
    echo "Branch $BRANCH does not exist. Please create it first."
    exit 1
fi

# Checkout the correct branch
echo "Checking out $BRANCH branch..."
git checkout $BRANCH

# Pull the latest changes from the remote
echo "Pulling the latest changes from $BRANCH branch..."
git pull origin $BRANCH

# Add changes to git
echo "Adding changes to git..."
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "No changes to commit."
else
    # Commit the changes
    echo "Committing changes..."
    git commit -m "Deploying latest changes to $BRANCH"
    
    # Push changes to GitHub
    echo "Pushing changes to $BRANCH branch..."
    git push origin $BRANCH
fi

echo "Deployment to $BRANCH completed."
