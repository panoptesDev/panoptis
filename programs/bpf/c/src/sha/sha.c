/**
 * @brief SHA256 Syscall test
 */
#include <solana_sdk.h>

extern uint64_t entrypoint(const uint8_t *input) {

  // SHA256
  {
    uint8_t result[SHA256_RESULT_LENGTH];
    uint8_t expected[] = {0x9f, 0xa2, 0x7e, 0x8f, 0x7b, 0xc1, 0xec, 0xe8,
                          0xae, 0x7b, 0x9a, 0x91, 0x46, 0x53, 0x20, 0xf,
                          0x1c, 0x22, 0x8e, 0x56, 0x10, 0x30, 0x59, 0xfd,
                          0x35, 0x8d, 0x57, 0x54, 0x96, 0x47, 0x2c, 0xc9};

    uint8_t bytes1[] = {'G', 'a', 'g', 'g', 'a', 'b', 'l', 'a',
                        'g', 'h', 'b', 'l', 'a', 'g', 'h', '!'};
    uint8_t bytes2[] = {'f', 'l', 'u', 'r', 'b', 'o', 's'};
    const SafeBytes bytes[] = {{bytes1, PANO_ARRAY_SIZE(bytes1)},
                              {bytes2, PANO_ARRAY_SIZE(bytes2)}};

    sol_sha256(bytes, PANO_ARRAY_SIZE(bytes), result);

    sol_assert(0 == sol_memcmp(result, expected, SHA256_RESULT_LENGTH));
  }

  // Keccak
  {
    uint8_t result[KECCAK_RESULT_LENGTH];
    uint8_t expected[] = {0xd1, 0x9a, 0x9d, 0xe2, 0x89, 0x7f, 0x7c, 0x9e,
                          0x5,  0x32, 0x32, 0x22, 0xe8, 0xc6, 0xb4, 0x88,
                          0x6b, 0x5b, 0xbb, 0xec, 0xd4, 0x42, 0xfd, 0x10,
                          0x7d, 0xd5, 0x9a, 0x6f, 0x21, 0xd3, 0xb8, 0xa7};

    uint8_t bytes1[] = {'G', 'a', 'g', 'g', 'a', 'b', 'l', 'a',
                        'g', 'h', 'b', 'l', 'a', 'g', 'h', '!'};
    uint8_t bytes2[] = {'f', 'l', 'u', 'r', 'b', 'o', 's'};
    const SafeBytes bytes[] = {{bytes1, PANO_ARRAY_SIZE(bytes1)},
                              {bytes2, PANO_ARRAY_SIZE(bytes2)}};

    sol_keccak256(bytes, PANO_ARRAY_SIZE(bytes), result);

    sol_assert(0 == sol_memcmp(result, expected, KECCAK_RESULT_LENGTH));
  }

  return SUCCESS;
}
