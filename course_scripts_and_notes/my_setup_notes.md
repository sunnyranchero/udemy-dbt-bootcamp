# Setup
_**Intended audience**: just my personal use._

The beginning of the project starts with the simple creation of a free snowflake account but this requires some steps.
The full course files are located here: [course_document_git_clone_link](https://github.com/nordquant/complete-dbt-bootcamp-zero-to-hero.git)


**Steps**   
- Account creation
    - expires in 30 days but you can just make a new one.
- [SSL key creation (using unencrypted for the 1st round)](https://docs.snowflake.com/en/user-guide/key-pair-auth)
    - There are 2 forms: encrypted and unencrypted
    - The encrypted needs a password entered during every connection.
    - If one is chosen, you may change it at any time.
    - There are a few ways to manage the password for the encryption.
        - .env file and then reference this within the project yaml.
    - There is also a Programmatic access token that can be generated.
        - It seems this is just a replacement for a password that has a time expiration
    - For Bash unencrypted:
        - Create the RSA key with `openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt`
        - Create the public key from the above output with `openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub`
        - Also, keep in mind that the header and the footer need to be removed. Only use the main body of the key.
    -
 - [Running the setup scripts from the course selection.](https://github.com/nordquant/complete-dbt-bootcamp-zero-to-hero/blob/main/_course_resources/course-resources.md)
- You'll also need the UV pages available in this repo link: [uv_pkgs](https://github.com/nordquant/dbt-student-repo.git)
- If you need the UV install script, check this link:
    - [Main UV website](https://docs.astral.sh/uv/getting-started/installation/#upgrading-uv)
- The prof also provided the toml and uv.lock file in this repo [dbt-student-repo](https://github.com/nordquant/dbt-student-repo.git)
    - There was supposed to also be a .python version file but it is not a hard requirement to get UV working.
    - Simply running uv sync will not only create the venv but it will also create the uv.lock file if you had not created one already
    - A note about uv lock files
        - This file is managed by `uv` itself by the `uv sync` command as well as `uv lock`
        - In order to add a package to it, simply add a line to the pyproject.toml
    - A new python project using `uv` is pretty easy to.
        - Start it like normal: a folder and you can add any number of files.
        - to get a `pyproject.toml`, you can make it manual or use `uv init <proj-name> && cd <proj-name>` to generate a basic one.
            - note if you already have a directory but need to create everything including the venv, just go into the directory and run vanilla `uv init`
        - then you can use `uv add <package name>` to add a new python package to the project.
            - The `<package name>` is whatever the python package name is called.
    - You can also convert from the old `venv` version with a `requirements.txt` to the `uv` style by the following (needs some slight review)
        - Make sure you have a requirements.txt file for the current environment.
        - Run `uv init` from within the project directory.
            - creates a basic toml and lock
            - You can also read in your requirements.txt file using something like `uv add -r requirements.in -c requirements.txt`
            - delete your old venv directory.
            - `uv sync`
            - then activate your new venv.
- Then setup your dbt environment, the pyproject already has the dbt packages downloaded. Once activated, you should be able to run the command.
    - use `dbt init --skip-profile-setup airbnb`. This will prevent the walkthrough prompts when creating the environment.
    
        



***
### Example code
This section is an example of the environment var in the profiles yaml.

```
# profiles.yml
my_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account
      user: your_user
      authenticator: externalbrowser
      private_key_path: /path/to/rsa_key.p8
      private_key_passphrase: "{{ env_var('SNOWFLAKE_PASSPHRASE') }}"
      database: your_db
      schema: your_schema
      threads: 4
      client_session_keep_alive: False
```
It does require an export command to set the variable before running the project.
```
export SNOWFLAKE_PASSPHRASE="your_passphrase"
```

Alternatively you can also include it in your python-dotenv file
```
# .env
SNOWFLAKE_PASSPHRASE=your_passphrase
```
And then load it to your project/shell before running dbt. Just remember to add the .env to the gitignore.


Some extra things to note
(I used an AI as a research assistant rather than having it do the work.):

⚠️ Security note for local dev:
Since this is just for learning, you’re fine. But remember:

- Don’t commit profiles.yml with sensitive values (add it to .gitignore)
- Never hardcode the passphrase in the file
- Clear the env var when you’re done: unset SNOWFLAKE_PASSPHRASE


🚀 Bonus: VS Code integration

You can also make VS Code’s “Terminal” load the env var automatically by creating a .env file in your project root.

Then install the “DotENV” extension for VS Code — it’ll auto-load the .env into your integrated terminal.

