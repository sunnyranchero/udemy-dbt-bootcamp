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
    - I left the public RSA keys in the snowflake starter scripts. The session expires soon and the key won't be usable.
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
- Inside snowflake, there are 3 different identifiers:
    - The Account identifier (us `SELECT CURRENT_ACCOUNT();`) > WD93490
    - The Org identifier (appears under the profile popup) > AAKRBAA used for routing
    - And the display name > UC68357
    - to confuse things more, this is the example of the url `https://app.snowflake.com/aakrbaa/uc68357/#/workspaces/ws/USER%24/PUBLIC/DEFAULT%24/scratch.sql`
    - It turns out I needed this: AAKRBAA-UC68357 for it to actually connect. This format is like this `<ORG_ID>-<ACCOUNT_NAME>`. I also did not find this in the docs. It seems like the docs have not kept up over the years and even some online tuts are showing different things.
- for the seeds section:
    - The recommend running this `curl https://dbtlearn.s3.us-east-2.amazonaws.com/seed_full_moon_dates.csv -o seeds/seed_full_moon_dates.csv`
    - then run `dbt seed`
    - dbt will try to figure out the data types for the fields.

General sql:
    - There are a few types of Slowly Changing Dimension (SCD) tables
        - Type 1
        - Type 2 > new row with the change but there is a valid_from and valid_to field. Soft delete.
        - Type 3
        - Type 4 
        

## DBT commands & Notes
DBT commands
- `dbt run` > this is simply building all the models
- `dbt run --full-refresh` > build all models from scratch, even incrementals.
- `dbt build` > build and test all models, creates all snapshots. Runs ` dbt test && dbt snapshot && dbt run`
- `dbt seed` > import the seed from source dir.
- `dbt compile` > just makes sure that everything can be processed without actually pushing it to the database. > This can also render Jinja directly to the screen if you use --inline 'my_jinja_text'
- `dbt source freshness` > just checks if the data is fresh or not compared to what was configured in the sources.yml
    - exit code is non-zero when it hits a nonfresh error. In linux `echo $?` should list it.
- `dbt snapshot` > creates the snapshot when run and updates the snapshot when run again.
- `dbt test` > executes the tests for all of the models
- `dbt test -s dim_listings_minimum_nights` > you can also just test 1 of your tests by listing out the actual name of the test after the -s flag.
- `dbt compile --inline '{{ select_positive_values(dim_listings_cleansed, minimum_nights) }}'`
    > This is how to render jinja in the command line using the dbt jinja engine. Shows the sql
- `dbt show --inline '{{ select_positive_values(dim_listings_cleansed, minimum_nights) }}'`
    > This is how to render jinja in the command line using the dbt jinja engine
- `dbt compile --inline 'SELECT * FROM {{ ref("dim_listings_cleansed") }} WHERE {{ no_empty_strings(ref("dim_listings_cleansed")) }}'` Another example that could use a macro.
- `dbt deps` > this is how you install packages from your `packages.yml` file.
- `dbt docs generate` > create the docs based on your models.
    - Then run `dbt docs serve` to run the light weight docs server. Python based. But you may want to use a better server than this in production.
- `dbt run --debug` - will show more information that is not really shown, such as the "grants" statement.
- `dbt test --select source:airbnb.listings` > Select the source instead of a model.
- `dbt --debug test --select source:airbnb.listings` >  is 1 way to debug a test. 
- `dbt run-operation [name_of_macro]` > this is how you would run a macro by itself.
    
DBT Notes
- materializations (denoted by materialized)
    - table
    - view
    - emphemeral (intermediate table like a cte that never gets full put into the target but is used to produce a result and then disappear. Think something like a lookup table or query)
    - incremental (increments on a specific field, is a table at its core.)
- If you switch a view/table to ephemeral, it will not delete the view by default. You may do that on your own at the db level.
- DBT stores run info in this target dir:
    - `code target/run/airbnb/models/dim/dim_listings_cleansed.sql`
    - This is the actual sql code dbt generated and executed.
- dbt uses snapshots for SCD tables.
- You can have snapshot configs in either the model folder with a `_snapshots.yml` prefix or in the snapshots dir.
    - The teacher recommends the model folder but either is fine. He also mentioned keeping it to 1 snapshot per file.
- The tests are designed to generate the code needed to test and ideally return 0 records.
- When it comes to unit tests, you may also put it in any subfolder under "tests" like "./tests/unit/my_test_name or under model. In the example, the prof preferred to put it under the model directory.
    - It can be called anything.yml
- Then there are analyses that can be created. These are simply things you want to run sql for but want to leverage dbt's engine to create the query.
You can find these after running `dbt compile`:
`./target/compiled/dbtlearn/analyses/...` with ... being the analysis name.
- there are also different types of hooks, 4 specifically:
    - `on_run_start` - when dbt starts running
        - put this in the dbt_project.yaml
    - `on_run_end` -  when dbt ends running
        - put this in the dbt_project.yaml
    - `pre-hook` - specifically at the model,seed, snapshot level before it runs.
    - `post-hook` - specifically at the model,seed, snapshot level after it runs.
- Another package the proj wants us to use is dbt-expectations: https://github.com/calogica/dbt-expectations


### Connecting to Preset.io data dashboard
This will be harder to actually do with the key pair. The proj mentioned that there was a way to auto generate the items needed, I'm assuming from his automated setup. I'm doing it the hard way.
You can find the docs here [preset.io instructions for snowflake](https://docs.preset.io/docs/snowflake_)

The first step involves building this out: `snowflake://<Username>@<Account>/<Database>?role=<Role>&warehouse=<Warehouse>`. This is called the URI for SQLAlchemy to use.
I think this is the final version: `snowflake://preset@AAKRBAA-UC68357/AIRBNB?role=REPORTER&warehouse=COMPUTE_WH`

```
SELECT 
  CURRENT_ACCOUNT() AS account_locator, 
  CURRENT_ORGANIZATION_NAME() AS org_identifier, 
  CURRENT_ACCOUNT_NAME() AS display_name;   
```





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

