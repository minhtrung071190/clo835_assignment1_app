# Default tags
output "default_tags" {
  value = {
    "Owner" = "DockerAssignment"
    "App"   = "Web"
    "Project" = "assignment"
  }
}

# Prefix to identify resources
output "prefix" {
  value = "assignment1"
}