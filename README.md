# RESTful API Codebase

## Setup local development environment

1. Use macOS, or Linux to development
1. Install required softwares:
    - PostgreSQL v13.3
    - MailHog (used for testing email)
    - Redis 6.2.x (cache service)
    - [Yarn](https://yarnpkg.com/) package manager
    - [Node.js](https://nodejs.org/) v14 or newer
    - [Visual Studio Code](https://code.visualstudio.com/download) with [ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) installed.


## Run the app locally

1. Start PostgreSQL server
2. Start MailHog server
3. Start Redis server
4. Copy file `.env.example` to a new file`.env`
5. Import sample data to your local database server:

```sh
# import to local database server
psql -d gravity -f ./sample-db.sql
```

6. Run migration

```sh
yarn migrate:run
```

7. Start the API server

```sh
yarn start:dev
```

8. Create an account in the system (by changing email of an existing account).

```sql
UPDATE users SET email='your@email.com' WHERE email='hqlam.bt@gmail.com';
UPDATE accounts SET google_login_id='your@email.com' WHERE google_login_id='hqlam.bt@gmail.com';
```

## Development workflow

### Develop new feature / bug fix

1. Checkout `master` branch
1. Create a new branch
    ```sh
    # for new feature
    git checkout -b feature/ticket-id/ticket-description

    # for bug fix
    git checkout -b fix/ticket-id/ticket-description
    ```
1. Create a **draft** pull request to `master` and push to Github.
1. When you finish the task, update the pull request's status to **Ready**, assign it to reviewer.

```sh
git checkout -b "feature/rename-workflow-file"
git add .
git commit -m "fix: rename workflow file"
git push --set-upstream origin "feature/rename-workflow-file"

git checkout master
git pull
```

### Hotfix

For developers:

1. Checkout code from production:
    ```sh
    git checkout v2.1.0
    ```
1. Create a new branch for the fix:
    ```
    git checkout -b hotfix/ticket-id/ticket-description
    ```
3. Push the hotfix branch to remote.

```sh
git checkout v0.0.8
git checkout -b hotfix/fix-urgent-bug
git add .
git commit -m "fix: urgent bug"
git push --set-upstream origin "hotfix/fix-urgent-bug" --no-verify
yarn release:hotfix
```

## Branching strategy

This project use [GitHub flow](https://guides.github.com/introduction/flow/). The following table is the rule of branch name.

| name | description |
| :--- | :--- |
| master | contains latest code, can only be deployed when a release tag is created (like a checkpoint)|
| feature/{name} | this branch is derived from master. use it when you develop a new function. |
| fix/{name} | this branch is derived from a master branch. use it when you fix bug. |
| hotfix/{name} | this branch is derived from a release tag. use it when you fix urgent bugs for a (released) version. |

Your branch name is automatically checked when committing by [git-branch-is](https://github.com/kevinoid/git-branch-is).


## Standards

### Code Style

- [TypeScript Style Guide](https://basarat.gitbook.io/typescript/styleguide) + [Airbnb Style Guide](https://github.com/airbnb/javascript).
- Code will be checked by linter (ESLint) before committing.
- Code pushing will be checked by unit test locally before transferring to remote repository. Unit test also has to pass test coverage minimum threshold defined in `jest.config.js` to ensure effective unit test.

### Commit message

- Commit message has to follow [conventional commit](https://conventionalcommits.org/) format.


### Branch name

- Check **Development Workflow** secion.


### File/directory name

- Use this format: `directory-name/file-name.{type}.ts`. `{type}` is type of the exported class (service, module, controller, guard, ...)
- Use `export` instead of `export default`.

**Bad**
```
SuperUsers/UserRole.ts
```

**Good**
```
super-user/user-role.service.ts
```

Reference:

- https://stackoverflow.com/questions/61666498/file-naming-in-nest-js


### Database (Postgres)

Check this [link](https://stackoverflow.com/a/2878408).


### Database (MongoDB)

- Collection name: use plural, camel case, no hyphens or underscores between words.
- Field name: use camel case.

**Bad**
```
customer-accounts.firstname
```

**Good**
```
customerAccounts.firstName
```

Reference:

- https://stackoverflow.com/questions/9868323/is-there-a-convention-to-name-collection-in-mongodb


### API design

Based on [PageDuty API](https://developer.pagerduty.com/docs/rest-api-v2/rest-api/), excepts:

- API version is specified in the URI, instead of header. Ex: http://domain/api/v1/*

- The API `GET /resources` return an array of resource, the total number of records (without pagination) will be defined in response header `X-Total-Count`:

```json
[
  {
    // fields appear here
    "field1": "abc",
    "field2": 123
  }
]
```
- The API `GET /resources/:id` return a single resource:

```json
{
  // fields appear here
  "field1": "abc",
  "field2": 123
}
```

- Query string will use camel case instead of separated by underscore. Ex: http://domain/api/v1/products?sortBy=name

- API route will be prefixed with module name. Ex: http://domain/api/v1/catalog/products (`catalog` is the module name)

- In case the API request is unsuccessful due to input validation error, The **error details** in response body will be an object with key name is name of invalid input field and value is error reason:

```json
{
  "error": {
    "message": "Error Message String",
    "code": "ERROR_CODE",
    "details": {
      "name": "REQUIRED",
      "email": "INVALID_EMAIL",
      // ...other fields
    }
  }
}
```

- Access Token should be sent in the request as part of an `Authorization` header, using this format:

```
Authorization: Bearer {token-string}
```


## Available Scripts

In the project directory, you can run:

| command | description |
| :--- | :--- |
| `yarn start:dev` | Runs the app in the development mode |
| `yarn start:prod` | Runs the app in the production mode |
| `yarn test` | Launch unit test runner with coverage information |
| `yarn test:e2e` | Launch end to end test |
| `yarn release` | Bump the version in `package.json` and update changelog |
| `yarn deploy` | trigger a deployment by creating a release tag |
| `yarn release:alpha` | Create an alpha release and trigger a deployment |


## Tech stack / Technologies / Frameworks

- Nodejs v14
- TypeScript v4
- NestJS v8
- PostgreSQL v13
- Swagger (for API documentation)
- Docker
- Jest (unit test runner)
- ESLint (code style checker)
- Commitlint (check commit message)
- Github Actions (for CI/CD)


## Used AWS Services

- Elastic Container Service
- Certificate Manager
- EC2
- Elastic Container Registry
- S3
- RDS
- CloudWatch
- Secrets Manager
- Certificate Manager
- CloudFormation


## AWS Policies for Administration

- AmazonRDSFullAccess
- AmazonEC2FullAccess
- SecretsManagerReadWrite
- IAMFullAccess
- AmazonEC2ContainerRegistryFullAccess
- AmazonS3FullAccess
- CloudWatchFullAccess
- AmazonECS_FullAccess
- AWSCertificateManagerFullAccess
- AWSCloudFormationFullAccess
