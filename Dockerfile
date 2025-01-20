# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project file and restore any dependencies (via nuget)
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application source code
COPY . ./

# Publish the application to the /app/publish directory
RUN dotnet publish -c Release -o /app/publish

# Use the official .NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final

# Set the working directory inside the container
WORKDIR /app

# Copy the published app from the build container
COPY --from=build /app/publish .

# Expose the port the app will run on
EXPOSE 80

# Set the entry point for the application
ENTRYPOINT ["dotnet", "YourApp.dll"]
