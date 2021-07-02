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

## Create Project
`POST /api/v1/projects`
```json
body:
{
  "user_id": "2",
  "api_key": "<api_kay>",
  "start_date": "2021-05-16",
  "end_date": "2025-07-11",
  "name": "Big Project",
  "hours_per_day": 8,
  "days_of_week": [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ]
}
```
```json
{
  "data": {
    "id": "204",
    "type": "project",
    "attributes": {
      "start_date": "2021-05-16",
      "end_date": "2025-07-11",
      "name": "Big Project",
      "company_id": 1384,
      "hours_per_day": 8,
      "work_days": [
        {
          "id": 311,
          "project_id": 204,
          "day_of_week_id": 2697,
          "created_at": "2021-07-01T23:15:10.645Z",
          "updated_at":"2021-07-01T23:15:10.645Z"
        },
        {
          "id": 312,
          "project_id": 204,
          "day_of_week_id": 2698,
          "created_at": "2021-07-01T23:15:10.648Z",
          "updated_at":"2021-07-01T23:15:10.648Z"
        },
        {
          "id": 313,
          "project_id": 204,
          "day_of_week_id": 2699,
          "created_at": "2021-07-01T23:15:10.650Z",
          "updated_at":"2021-07-01T23:15:10.650Z"
        },
        {
          "id": 314,
          "project_id": 204,
          "day_of_week_id": 2700,
          "created_at": "2021-07-01T23:15:10.652Z",
          "updated_at":"2021-07-01T23:15:10.652Z"
        },
        {
          "id": 315,
          "project_id": 204,
          "day_of_week_id": 2701,
          "created_at": "2021-07-01T23:15:10.654Z",
          "updated_at":"2021-07-01T23:15:10.654Z"
        }
      ]
    }
  }
}
```
