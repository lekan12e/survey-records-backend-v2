# =========================
# BUILD STAGE
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy project file and restore dependencies
COPY survpai.csproj ./
RUN dotnet restore

# Copy everything else
COPY . ./

# Publish the app
RUN dotnet publish -c Release -o /out

# =========================
# RUNTIME STAGE
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy published files
COPY --from=build /out .

# Render uses port 10000
EXPOSE 10000
ENV ASPNETCORE_URLS=http://+:10000

# Start the app
ENTRYPOINT ["dotnet", "survpai.dll"]
