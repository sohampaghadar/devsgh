# Use the official .NET SDK image to build and publish the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory
WORKDIR /src

# Copy the csproj file and restore any dependencies (via nuget)
COPY ["YourApp/YourApp.csproj", "YourApp/"]
RUN dotnet restore "YourApp/YourApp.csproj"

# Copy the entire project and build/publish the app
COPY . .
WORKDIR "/src/YourApp"
RUN dotnet publish "YourApp.csproj" -c Release -o /app/publish

# Use the official .NET Runtime image for the runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory in the container
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /app/publish .

# Expose port 80 to the outside world
EXPOSE 80

# Define the entry point of the container (run the application)
ENTRYPOINT ["dotnet", "YourApp.dll"]
