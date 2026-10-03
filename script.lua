print("My first remote script works!")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Success",
    Text = "Script loaded from GitHub!",
    Duration = 5
})
