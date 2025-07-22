"""
API Performance Tests using Locust
Tests various API endpoints for load and performance
"""
from locust import HttpUser, task, between
import random


class APIPerformanceUser(HttpUser):
    """
    Performance test user that simulates API usage patterns
    """
    # Wait between 1-3 seconds between tasks to simulate real user behavior
    wait_time = between(1, 3)
    
    def on_start(self):
        """Called when a user starts - setup any initial data"""
        self.user_ids = list(range(1, 11))  # User IDs 1-10 for testing
        
    @task(3)  # Weight: 3 (most common operation)
    def get_users(self):
        """Test GET /users endpoint - most frequent operation"""
        self.client.get("/users", name="Get All Users")
        
    @task(2)  # Weight: 2  
    def get_single_user(self):
        """Test GET /users/{id} endpoint"""
        user_id = random.choice(self.user_ids)
        with self.client.get(f"/users/{user_id}", name="Get Single User", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            elif response.status_code == 404:
                response.failure("User not found")
            else:
                response.failure(f"Unexpected status code: {response.status_code}")
                
    @task(2)
    def get_posts(self):
        """Test GET /posts endpoint"""
        self.client.get("/posts", name="Get All Posts")
        
    @task(1)  # Weight: 1 (less frequent)
    def get_user_posts(self):
        """Test GET /users/{id}/posts endpoint"""
        user_id = random.choice(self.user_ids)
        self.client.get(f"/users/{user_id}/posts", name="Get User Posts")
        
    @task(1)
    def get_comments(self):
        """Test GET /comments endpoint"""
        self.client.get("/comments", name="Get All Comments")
        
    @task(1)
    def create_post(self):
        """Test POST /posts endpoint - simulate creating content"""
        post_data = {
            "title": f"Performance Test Post {random.randint(1, 1000)}",
            "body": "This is a test post created during performance testing",
            "userId": random.choice(self.user_ids)
        }
        with self.client.post("/posts", json=post_data, name="Create Post", catch_response=True) as response:
            if response.status_code == 201:
                response.success()
            else:
                response.failure(f"Failed to create post: {response.status_code}")


class APIStressUser(APIPerformanceUser):
    """
    Stress test user with more aggressive behavior
    """
    wait_time = between(0.1, 0.5)  # Much shorter wait times for stress testing
    
    @task(5)
    def rapid_user_requests(self):
        """Rapid fire user requests for stress testing"""
        for _ in range(3):  # Make 3 rapid requests
            user_id = random.choice(self.user_ids)
            self.client.get(f"/users/{user_id}", name="Rapid User Requests")


# Configuration for different test scenarios
class LightLoadUser(APIPerformanceUser):
    """Light load simulation - normal business hours"""
    wait_time = between(2, 5)


class HeavyLoadUser(APIPerformanceUser):  
    """Heavy load simulation - peak traffic"""
    wait_time = between(0.5, 2)
