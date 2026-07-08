// Filesystem repository — use when data is stored as files on disk identified by a key (no database).
// baseDir is injected from @ConfigurationProperties — never hardcoded.
// All keys are untrusted: validate format, normalize, then enforce path-traversal guard.
class ResourceFilesystemRepository implements ResourceRepository {

  private final Path baseDir;

  ResourceFilesystemRepository(AppConfigurationProperties properties) {
    this.baseDir = properties.resourceDir();
  }

  @Override
  public String findByKey(String key) {
    // 1. Validate key format against allowlist (e.g. regex).
    // 2. Normalize to canonical form.
    // 3. Resolve path.
    // 4. Enforce: filePath.normalize().startsWith(baseDir.normalize()) — throw
    // bad-request if not.
    // 5. Read with Files.readString(path, StandardCharsets.UTF_8);
    // catch NoSuchFileException → rethrow as domain NotFoundException.
    // ...
  }
}
