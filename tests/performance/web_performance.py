"""
Web Performance Tests using Locust
Tests web application performance by simulating user interactions
"""
from locust import HttpUser, task, between
import random
import re


class WebPerformanceUser(HttpUser):
    """
    Simulates real user behavior on the website
    """
    wait_time = between(2, 5)  # Users typically take 2-5 seconds between actions
    
    def on_start(self):
        """Setup initial session data"""
        self.csrf_token = None
        self.session_cookies = {}
        
    def get_csrf_token(self, response_text):
        """Extract CSRF token from HTML response if present"""
        csrf_match = re.search(r'name="csrf_token" value="([^"]*)"', response_text)
        if csrf_match:
            return csrf_match.group(1)
        return None
        
    @task(5)  # Most common - users browse the homepage frequently
    def load_homepage(self):
        """Load the main homepage"""
        with self.client.get("/", name="Homepage", catch_response=True) as response:
            if response.status_code == 200:
                # Check for key elements that should be present
                if "Automation Exercise" in response.text:
                    response.success()
                else:
                    response.failure("Homepage missing key content")
            else:
                response.failure(f"Homepage failed: {response.status_code}")
                
    @task(3)  # Common user action
    def browse_products(self):
        """Navigate to products page"""
        with self.client.get("/products", name="Products Page", catch_response=True) as response:
            if response.status_code == 200:
                if "All Products" in response.text or "products" in response.text.lower():
                    response.success()
                else:
                    response.failure("Products page missing expected content")
            else:
                response.failure(f"Products page failed: {response.status_code}")
                
    @task(2)  # Users search for products
    def search_products(self):
        """Search for products"""
        search_terms = ["shirt", "jeans", "dress", "shoes", "jacket"]
        search_term = random.choice(search_terms)
        
        # First load products page
        self.client.get("/products", name="Products Page for Search")
        
        # Then perform search
        search_data = {"search": search_term}
        with self.client.post("/search_product", data=search_data, name="Product Search", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Search failed: {response.status_code}")
                
    @task(2)  # Browse specific product details
    def view_product_details(self):
        """View individual product details"""
        # Simulate clicking on a product (product IDs typically 1-34 in the demo site)
        product_id = random.randint(1, 34)
        with self.client.get(f"/product_details/{product_id}", name="Product Details", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Product details failed: {response.status_code}")
                
    @task(1)  # Less frequent - user signup/login flow
    def signup_login_page(self):
        """Load signup/login page"""
        with self.client.get("/login", name="Signup/Login Page", catch_response=True) as response:
            if response.status_code == 200:
                if "login" in response.text.lower() or "signup" in response.text.lower():
                    response.success()
                else:
                    response.failure("Login page missing expected content")
            else:
                response.failure(f"Login page failed: {response.status_code}")
                
    @task(1)  # Contact form access
    def contact_page(self):
        """Load contact us page"""
        with self.client.get("/contact_us", name="Contact Page", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Contact page failed: {response.status_code}")
                
    @task(1)  # Test case/api page (if available)
    def test_cases_page(self):
        """Load test cases page"""
        with self.client.get("/test_cases", name="Test Cases Page", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Test cases page failed: {response.status_code}")


class MobileUserSimulation(WebPerformanceUser):
    """
    Simulates mobile user behavior with longer wait times
    """
    wait_time = between(3, 8)  # Mobile users typically slower
    
    def on_start(self):
        super().on_start()
        # Add mobile user agent
        self.client.headers.update({
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15"
        })


class PowerUserSimulation(WebPerformanceUser):
    """
    Simulates power users who navigate quickly
    """
    wait_time = between(0.5, 2)  # Fast navigation
    
    @task(10)  # Power users do lots of searches
    def rapid_product_browsing(self):
        """Rapidly browse multiple products"""
        for _ in range(3):
            product_id = random.randint(1, 34)
            self.client.get(f"/product_details/{product_id}", name="Rapid Product Browsing")


class ECommerceUserJourney(WebPerformanceUser):
    """
    Simulates a complete user journey through the e-commerce site
    """
    def on_start(self):
        super().on_start()
        self.cart_items = []
        
    @task
    def complete_shopping_journey(self):
        """Simulates a complete shopping session"""
        # 1. Start at homepage
        self.client.get("/", name="Journey: Homepage")
        
        # 2. Browse products
        self.client.get("/products", name="Journey: Browse Products")
        
        # 3. Search for something specific
        search_terms = ["shirt", "dress", "jeans"]
        search_term = random.choice(search_terms)
        self.client.post("/search_product", data={"search": search_term}, name="Journey: Search")
        
        # 4. View product details
        product_id = random.randint(1, 10)
        self.client.get(f"/product_details/{product_id}", name="Journey: Product Details")
        
        # 5. Potentially add to cart (simulate with view cart)
        self.client.get("/view_cart", name="Journey: View Cart")
        
        # Wait longer between complete journeys
        self.wait_time = between(10, 20)
