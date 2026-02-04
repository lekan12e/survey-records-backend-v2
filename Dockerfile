FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /src

COPY . .
RUN set -e; \
    echo "Listing repo root:"; ls -la; \
    echo "Finding csproj:"; find . -maxdepth 4 -name '*.csproj' -print; \
    proj="$(find . -maxdepth 4 -name '*.csproj' -print -quit)"; \
    if [ -z "$proj" ]; then \
      echo "Could not find a csproj to build." && exit 1; \
    fi; \
    echo "Using csproj: $proj"; \
    dotnet restore "$proj" -v detailed; \
    dotnet publish "$proj" -c Release -o /app/publish /p:UseAppHost=false -v detailed

FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "survpai.dll"]
