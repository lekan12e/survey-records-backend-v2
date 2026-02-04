# =========================
# BUILD STAGE
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source code
COPY . ./

# Build and publish the app
RUN dotnet publish -c Release -o /out

# =========================
# RUNTIME STAGE
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

# Copy published output from build stage
COPY --from=build /out .

# Render listens on port 10000
EXPOSE 10000
ENV ASPNETCORE_URLS=http://+:10000

# 🔥 CHANGE ONLY THIS LINE
ENTRYPOINT ["dotnet", "survpai.dll"]
