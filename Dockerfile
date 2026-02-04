FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /src

COPY . .
RUN set -e; \
    proj="$(find . -maxdepth 4 -name '*.csproj' -print -quit)"; \
    if [ -z "$proj" ]; then \
      echo "Could not find a csproj to build." && exit 1; \
    fi; \
    dotnet restore "$proj"; \
    dotnet publish "$proj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "survpai.dll"]
