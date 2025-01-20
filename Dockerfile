# Use the official .NET image as a base
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Program.cs", "./"]
RUN dotnet restore "./Program.cs"
RUN dotnet publish "Program.cs" -c Release -o /app/publish

# Final stage: copy the published files from build stage to base
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Program.dll"]
