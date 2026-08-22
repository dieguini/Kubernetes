# Doc: https://docs.locust.io/en/stable/

# This is the python script that goes in the configmap
from locust import HttpUser, between, task

class WebSiteStressTestUsers(HttpUser):
    wait_time = between(0.7, 1.3)
    
    @task
    def stress_test_users(self):
        self.client.get("/", headers={"Host": "my.podinfo.local"})
        
