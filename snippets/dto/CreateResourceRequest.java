public record CreateResourceRequest(
    @NotBlank String name,
    @NotBlank @Size(max = 255) String description) {
}
