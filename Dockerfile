FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /src

COPY . .
RUN if [ -f "survpai/survpai.csproj" ]; then \
      dotnet restore "survpai/survpai.csproj"; \
      dotnet publish "survpai/survpai.csproj" -c Release -o /app/publish /p:UseAppHost=false; \
    elif [ -f "survpai.csproj" ]; then \
      dotnet restore "survpai.csproj"; \
      dotnet publish "survpai.csproj" -c Release -o /app/publish /p:UseAppHost=false; \
    else \
      echo "Could not find a csproj to build." && exit 1; \
    fi

FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "survpai.dll"]
