"""
Main Locust configuration file - Entry point for performance tests
Run with: locust -f tests/performance/locustfile.py
"""
from locust import HttpUser, task, between
from api_performance import APIPerformanceUser, LightLoadUser, HeavyLoadUser
from web_performance import WebPerformanceUser, MobileUserSimulation, PowerUserSimulation


class DefaultPerformanceUser(HttpUser):
    """
    Default mixed-scenario performance user
    Combines both API and Web testing
    """
    wait_time = between(1, 3)
    
    # Set base URL - can be overridden with --host parameter
    host = "https://automationexercise.com"
    
    @task(3)
    def web_homepage(self):
        """Load homepage like a regular user"""
        self.client.get("/", name="Homepage")
        
    @task(2) 
    def web_products(self):
        """Browse products"""
        self.client.get("/products", name="Products Page")
        
    @task(1)
    def web_search(self):
        """Search for products"""
        search_data = {"search": "shirt"}
        self.client.post("/search_product", data=search_data, name="Product Search")


# For API testing, change host to API endpoint
class APITestUser(APIPerformanceUser):
    """API-focused performance testing"""
    host = "https://jsonplaceholder.typicode.com"
    

# Different load profiles
class LightLoad(WebPerformanceUser):
    """Light load - normal traffic"""
    weight = 3
    host = "https://automationexercise.com"


class HeavyLoad(WebPerformanceUser):
    """Heavy load - peak traffic"""  
    weight = 1
    wait_time = between(0.5, 1.5)
    host = "https://automationexercise.com"


class MobileTraffic(MobileUserSimulation):
    """Mobile user simulation"""
    weight = 2
    host = "https://automationexercise.com"
