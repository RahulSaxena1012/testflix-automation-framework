import requests
import allure

@allure.title("GET / users return user list")
@allure.description("Verifies the /users endpoint returns a valid non-empty user list.")
def test_get_users():
    response = requests.get("https://jsonplaceholder.typicode.com/users")
    assert response.status_code == 200
    assert len(response.json()) > 0