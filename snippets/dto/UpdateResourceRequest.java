public record UpdateResourceRequest(
    @NotBlank String name,
    @NotBlank @Size(max = 255) String description) {
}
