# Create a file GitHub Action

This action creates a file with the given content and return path to the file.

## Inputs

### `file-path`

**Not required** Path to the file.  
Default `"${working directory}/create-file-${{ github.run_id }}-${{ github.run_attempt }}"`.  
Example: `/home/runner/work/iac/iac/create-file-12896420513-3`

### `file-content`

**Required** Content to populate the file with.

## Outputs

### `file-path`

Path to the file.
Example: `/home/runner/work/iac/iac/create-file-12896420513-3`

## Example usage

```yaml
  - name: Create a file
    id: create-a-file
    uses: ./.github/actions/create-file
    with:
      file-content: '${{ env.SOME_ENV_VAR }}'
```
