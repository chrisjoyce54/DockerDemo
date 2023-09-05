#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DemoCoreWebAPI/DemoCoreWebAPI.csproj", "DemoCoreWebAPI/"]
RUN dotnet restore "DemoCoreWebAPI/DemoCoreWebAPI.csproj"
COPY . .
WORKDIR "/src/DemoCoreWebAPI"
RUN dotnet build "DemoCoreWebAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DemoCoreWebAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoCoreWebAPI.dll"]

#docker build --rm -t poc/democorewebapi:latest .
#docker run --rm -d -p 8080:80 poc/democorewebapi
#