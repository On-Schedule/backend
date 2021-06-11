# Fetching Friends API Contract

## Endpoints

| HTTP verbs | Paths  | Used for | Output |
| ---------- | ------ | -------- | ------:|
| POST | /api/v1/users | Create a new user | [json](#create-user) |
| GET | /api/v1/users/:user_id?api_key='api_key' | Get a user| [json](#get-user) |
| POST | /api/v1/users/login | login validation for a user | [json](#login-user) |

## JSON Responses

## Create User
`POST /api/v1/users`
```json
body:
{
  "company_id": "10",
  "first_name": "Doug",
  "last_name": "Welchons",
  "email": "email@domain.com",
  "password": "password",
  "password_confirmation": "password"
}
```
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "company_id": "10",
      "first_name": "Doug",
      "last_name": "Welchons",
      "api_key": "<api_key>"
    }
  }
}
```

## Get User
`GET /api/v1/users/1?api_key=<api_key>`
  ```json
  {
    "data": {
      "id": "1",
      "type": "user",
      "attributes": {
        "company_id": "1",
        "first_name": "Doug",
        "last_name": "Welchons",
        "api_key": "<api_key>"
      }
    }
  }
  ```

## Login User
`POST /api/v1/users/login`
```json
body:
{
  "email": "email@domain.com",
  "password": "password"
}
```
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "company_id": "10",
      "first_name": "Doug",
      "last_name": "Welchons",
      "api_key": "<api_key>"
    }
  }
}
```
