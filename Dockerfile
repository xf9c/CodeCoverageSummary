FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
COPY ["src/coverage.cobertura.xml", "/publish/sample.coverage.xml"]
WORKDIR /src
COPY ["src/CodeCoverageSummary/CodeCoverageSummary.csproj", "CodeCoverageSummary/"]
RUN dotnet restore CodeCoverageSummary/CodeCoverageSummary.csproj
COPY ["src/CodeCoverageSummary", "CodeCoverageSummary/"]
RUN dotnet publish CodeCoverageSummary/CodeCoverageSummary.csproj --configuration Release --no-restore --output /publish

# Label the container
LABEL repository="https://github.com/xf9c/CodeCoverageSummary"
LABEL homepage="https://github.com/xf9c/CodeCoverageSummary"

# Label as GitHub Action
LABEL com.github.actions.name="Code Coverage Summary Multi-arch"
LABEL com.github.actions.description="A GitHub Action that reads Cobertura format code coverage files and outputs a summary."
LABEL com.github.actions.icon="book-open"
LABEL com.github.actions.color="gray-dark"

FROM mcr.microsoft.com/dotnet/runtime:6.0 AS final
WORKDIR /app
COPY --from=build /publish .
ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "/app/CodeCoverageSummary.dll"]
