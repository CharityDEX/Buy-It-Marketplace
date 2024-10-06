# Api (version 1.0.0)
## get-product
```
curl --location --request POST 'http://server/api' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "get-product",
    "code": "3274490970953"
}'
```
### response
```json
{
    "valid": true,
    "product": {
        "ecoscore_data": {
            "score": 100,
            "total": 116,
            "grade": "a",
            "missing": null,
            "agribalyse": [
                {
                    "name": "Agriculture",
                    "value": "53.2"
                },
                {
                    "name": "Processing",
                    "value": "7.4"
                },
                {
                    "name": "Packaging",
                    "value": "27.4"
                },
                {
                    "name": "Transportation",
                    "value": "7.4"
                },
                {
                    "name": "Distribution",
                    "value": "3.2"
                },
                {
                    "name": "Consumption",
                    "value": "1.4"
                }
            ],
            "adjustments": [
                {
                    "value": 14,
                    "status": "low",
                    "text": "Low impact origins of ingredients",
                    "header": "Origins of Ingredients",
                    "imagePath": "http://server/static/ingredients.svg"
                },
                {
                    "value": -3,
                    "status": "low",
                    "text": "Packaging with low impact",
                    "header": "Packaging Information",
                    "imagePath": "http://server/static/packaging.svg"
                },
                {
                    "value": 0,
                    "status": "low",
                    "text": "No species were harmed",
                    "header": "Harmed Species",
                    "imagePath": "http://server/static/harmed.svg"
                },
                {
                    "value": 15,
                    "status": "low",
                    "text": "Contains positive labels",
                    "header": "Labels with Environmental Benefits",
                    "imagePath": "http://server/static/benefits.svg"
                }
            ]
        },
        "brands": "Maison Meneau,Meneau",
        "product_name": "Sirop Citron",
        "quantity": "1 l",
        "categories": "Boissons"
    },
    "code": "3274490970953",
    "status": true,
    "status_verbose": "product found"
}
```
---
## set-purchase
```
curl --location --request POST 'http://server/api'  \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "set-purchase",
    "purchase": [
        {
            "barcode": "123456",
            "qnty": 1,
            "points": 12
        },
        {
            "barcode": "987654",
            "qnty": 12,
            "points": 77
        },
        {
            "barcode": "123131231123",
            "qnty": 7,
            "points": 10
        }
    ]
}'
```
### response
``` json
{
    "status": true,
    "code": 0
}
```
"code" Ну вдруг понадобится прикрутить проверку, на то что параметры товара изменились, тогда можно вернуть какой нить код и возиции в которых расхождение
---
---
## get-me
```
curl --location --request POST 'http://server/api' \
--header 'Cookie;' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "get-me"
}'
```
### response
``` json
{
    "email": "sachakor@gmail.com",
    "userName": "amy_smith",
    "userText": null,
    "points": 1966
}
```
---
---
## get-me-photo
```
curl --location --request POST 'http://server/api' \
--header 'Cookie;' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "get-me-photo",
    "sizePhoto": 130
}'
```
if photoSize is null then photoSize=100
### response
```json
{
    "photo": "/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAKAAoDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwCW8ms/BsjSys00mwEov3jGXVSR2HUnB6469cPklE8jSnblyWOOnPNd4bO1ukiNxbQzFH3J5iBtpBBBGehrgNWRLfWb6GFVjijuJEREGFVQxAAA6AVjGjGMnPqzoqVG6cY9Ef/Z"
}
```
return photo in jpeg format in base64
---
---
## get-me-position
```
curl --location --request POST 'http://server/api' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "get-me-position"
}'
```
### response
```json
{
    "position": 2
}
```
---
---
## get-leader
```
curl --location --request POST 'http://server/api' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "get-leader"
}'
```
### response
```json
{
    "leaderItems": [
        {
            "name": "user2",
            "points": 20000,
            "photo": "/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAwADADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDt9dt7a+0q6WSOMs8LZY8k8V5N4bcv4N1a0LZELbwK6ubW473TBOrlWZDgbuq45rh/DOt2+m2uqW04UrfqY0ywyvXk/nXz2Hp1FSb5bvTT5nq81pK50/gfUJRcxr5uxRjOe9esi4zEADk+lfPtzZTPAzebCtvGgIXZna2MDPTGQBk9zycnpd8F+J9ZsJtPsbJFljeXHkuDghiCTlQSoAycgHHcHFaYjAOrGU6UtV0t+oOq4tQnH0Og8fTM+qtHITlUOAT0qfQLyG3+HWquWKypGxVwcEHHGKyvHFlqcuqXF8sLPDt6iuaj1ye38J3lg8MiCVhyykCsIYadTDQjF63X/BKlOUZNyVi3otve212unX8UgiJ2jdnC5revfC2hBlXynEpOQsZ2nPqCKy4NStZ75EW4FxK/PDbwpycYPc46+lWftHmxSRPLL5m7bGCCCv410yqVea6VjthQoqNm7mD4hsrDRZrM28MqrKXEu52bkbcHk+5/wrJ0HUZdL1y3uPMfZG2TtG4hejYHqQTUmr3k9/eTW22Z4bbCcjJVx1J/HI+gFVLS1vJJhNabzNEwZHD7ShBzn6//AK69WlG0Pfe+549ed6v7taJ6HtFzeEwSLNuLA8A9DWO0sF0m2eyUxqcZKDANYemzFPDpW+SU3FrKYonXONq4Gc9ODkfhWjdanbJaD9zMzyqA21d2W9a8Z0Zxna+x78KsJQTtucuj2o0qJ7C0DSJhCQqjy3IAyTkYGe/Penx6pcvbPJfIERTgea5SWNgvVc8nvx/+usGXUAtz5LRXsflyAtGZeVZTzlexByPbipLsHUb5YEuzKBGGNzcZ/d5ySM88DI9ea7nST+I4VWaV4FGee4hlkdwU89dzk87s5IP1waigkuUuBHAHjkkwAoOOo/ljmukfQJrmzt5Lh4Vj2qqIHB3dAcEHPGOnfNN1iC3+0w3McUkUuFUuACgxyMe/r1/nnf20PhON4apfmuTWq3cWlx2k14P9IZnjiKOzEjrgAHnOeDT7abXESKy1DSJ7lgAI0eQAhemCCDgcj0rOF/NJb3Md3JcxzyOWjmilKMwZuTtJ5Ht1z071NpN6lvCr3cl08/nDy0aQ+ZIxP8KlT044J5NYTind21OyErJK9kv61P/Z"
        },
        {
            "name": "amy_smith",
            "points": 9038,
            "photo": "/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAwADADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDCxRjNSFTVi10+4u2+RCE7ueAKhtLcpJsLC3jubuOKSdYgx79T7D/69dfDpWmwkOLTcy+rFs/gTiubsktrO9lmkZnFvKYchdxViBzx0BHQds+5rqYJVkXKNnsfb6ivn8zxVVTSg2ke9l2FjyNzSvf1LKLbToRHj5flKeg9CKwtQs0tLoLH911DgenOMfpWy1rl/tMTCKUD5j2dff8AzxWFPL9pupJdxKsx259Owqso53NvoTmrgoJdfyN+50mzgspJI7eIMMKMr696yDZC+j/s15J4Y5gQJo/lORzwR/nrXVSxCaJo2+61U9TjTNszbT5S4ULwN23/AOtXrzjd3Z5+Gcb+ev8AwPxOIv8AQJ7s28FheM1vFPi5845MjKR8xI5JwB1rW1p20fRZr62Y+bbR7h5jFg4HY1g2vinTNP146fdWskWpSyspaMAxgknAJznJ47de/eofHuo3R0nycKkcrquO57/0rCVNSfJJaM65V2tU9jrNP1+21fwzLeRgqzR7WjPBVjx+I68+xrMi7VwegakljqotUCpb3ARWAYkblXlue+4nPpk13icVrh8NGgnGJw4qu6zTZ3dMeEywy4Xc6qSoPTOKdT4p4omCPNEkjnKo7cuACWwO+BnpXRFXZhe2qPGdN8O3WpeNtTuJ4jI1rOxQMQu85zwenQ5/GsvxfczDU1S6k3LEg2oDkE+2Ovbmvb59AgCyPBDkB2YAEjLMSTk9zyBnpx0rBbwZpqasl/rAFzclQ3krxGABjGOpX2PXJyfQdNKXMzeMnJcsNWzy2Dwdrtx4ak1wWrCEJv8A9ooOS+PTkdAeh7V2mnzedp9tLu3bo1JPqcV6lpp0qe3aIxKwkXyzHIoIKkYK49MdvSuI8QaDB4aa2hs2LWpjwu7qCMZ/mD+dW7PVGNSLh7skf//Z"
        },
        {
            "name": "user3",
            "points": 2000,
            "photo": null
        }
    ]
}
```
---
---
## update-me
```
curl --location --request POST 'http://server/api' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "update-me",
    "userName": "user1",
    "userText": "userText",
    "photo": "..."
}'
```
update only not null fields
### response
```json
{
    "status": "Ok"
}
```
---
---
## login
```
curl --location --request POST 'http://server' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "login",
    "login": "user1",
    "password": "user1"
}'
```
### response
```json
{
    "refreshToken": "eyJhb...ftvr5u1-R35_kQ",
    "accessToken": "eyJhbG...awuxdS68s2A"
}
```
or status 404
``` json
{
    "text": "User not found"
}
```
---
---
## logout
```
curl --location --request POST 'http://server' \
--header 'Authorization: Bearer eyJhbGciOiJI...iM64yAP8qQh4hCYiw' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "logout"
}'
```
### response
``` json
{
    "status": "Ok"
}
```
or status 401
``` json
{
    "text": "Ошибка"
}
```
---
---
## refresh-token
```
curl --location --request POST 'http://server/api' \
--header 'Authorization: Bearer eyJhbGci...5iy9Swgg' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "refresh-token"
}'
```
### response
```json
{
    "refreshToken": "eyJhbGciO...H1B-HuJWoQ",
    "accessToken": "eyJhbGciOi...lap2OfaZ49iA"
}
```
or status 401
``` json
{
    "text": "Ошибка"
}
```
---
---
## signup
```
curl --location --request POST 'http://server' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "signup",
    "email": "user1@email.com",
    "login": "user1",
    "password": "user1"
}
```
### response
```json
{
  "status": "ok"
}
```
#### or status 412
``` json
{
    "text": "This userName exists"
}
```
---
---
## verify-code
```
curl --location --request POST 'http://server' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "verify-code",
    "email": "user1@email.com",
    "login": "user1",
    "password": "user1"
    "code": "0000"
}
```
#### При отправыке кода, нужно отправить email и login, что бы можно было верифицировать пользователя
### response
```json
{
  "refreshToken": "eyJhb...ftvr5u1-R35_kQ",
  "accessToken": "eyJhbG...awuxdS68s2A"
}
```
#### or status 404
``` json
{
    "text": "Code is not valid",
    "attempt": 2
}
```
#### or status 404
``` json
{
    "text": "Code is not valid. Attempt count is 0",
    "attempt": 0
}
```
### attempt - количество попыток, которые остались


---
## restore-password
```
curl --location --request POST 'http://server' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "restore-password",
    "login": "user1@email.com"
}
```
### response
```json
{
  "status": "ok"
}
```
---
---
## restore-verify-code
```
curl --location --request POST 'http://server' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "restore-verify-code",
    "login": "user1@email.com",
    "code": "0000"
}
```
#### При отправыке кода, нужно отправить email или имя, что бы можно было верифицировать пользователя
### response
```json
{
  "status": "ok"
}
```
#### or status 404
``` json
{
    "text": "Code not valid",
    "attempt": 2
}
```
### attempt - количество попыток, которые остались

---
## set-new-password
```
curl --location --request POST 'http://server' \
--header 'Content-Type: application/json' \
--data-raw '{
    "chain": "set-new-password",
    "login": "user1@email.com",
    "password": "newPassword",
    "code": "0000"
}
```
#### Нужно отправить email или имя, password и код верификации что бы можно было верифицировать пользователя
### response
```json
{
  "refreshToken": "eyJhb...ftvr5u1-R35_kQ",
  "accessToken": "eyJhbG...awuxdS68s2A"
}
```
#### or status 404
``` json
{
    "text": "Code not valid",
    "attempt": 0
}
```
### attempt - количество попыток, которые остались

---
