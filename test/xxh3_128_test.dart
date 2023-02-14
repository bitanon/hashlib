// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

const seed = 0x9e3779b1;
const seed64 = (0x9e3779b1 << 32) | 0x85ebca8d;
final cases = fromHex(
    '0052929bb732a3242d00af950eecb893e3dfef93aad6cd2a538b5c3f545a6fd559c0fffc8f85b9331dab74f7b6059327b07084b3677c9f76480072ed7b9817e8dd485e0c0ccbd0653fadb28f11b06ce88db0f186086159566c8e4e781363bdab9d327309ea712fd97a9d55f0ca8ad0e95e1a36b36b0fca51ef8ba2c462ed0096f33449eb0fd13b92a1a963dbaaed3dcff10942cdf9b321a2ebf2c8f4e42f48d14b10f4c2efecf84ab53874c3a4a6620ebffd633741e386981aeb4cba56036687ed004559c18544b6c368f941a9eaf987e09f12d0d51454485d444051e338069a4c3c0def6489f8a361eee3c51c9368c8e597d70998ff97a84ceaa479abcd2cc89f1bf2f1cee282503882ad8e9bb8b488818eb636d9a96548743cc9dbfcbbd82a229eb424e2b267abaa13e22a4dfc711c076291bdf8e2975d0c84fd6745671b099a4b20a2773095da28b1863f9ef2e1db10df90f86d912f0678b3485bdff6dbd87ca7aea589404c027320f09fdd637995b103c47e6f2fe022f6d488e9666e9d3519bd411b4f1acfd578b00049f01f8f8df614bcb5946dc45376a7a75391cf8db6166c397e362f06f2231e8e0fc886f476618ef66436fc8c27a1fa12cbfece583f8167886c7dc081e7f8c08e540ec9d9519d219035690a0baca171444b9f45fe9d981f1e1b776c5df1fb7e2c64fe6b571968cddde4d009361a609962d707e64d0986f78e9b2f42d983cba5caad2262757f5b40ef1aafec48756b22b5c405004d2a097d8b8d6ebb5cd4a6b2a10d24acaf16f37f6ebafd0d0791d263f1bb83de41481b7431e2f33f19a750f24e5bae206093d50c7ea5527798ecd52c0d52e75cae0484effbaecdb45cbac8ce982bd0a3a2e6256eb9cc066ab27f56578b4caa09214f4ac3904ba9d00736cf54119e27e39f503f58c294d47188a7814ed78f1e5d21ddc2016d5a1fd194b659885e377d176e8e1655107ccf70eae75029a542e03028a01e3dd559b168737022d33d2a634613aedb1e350598a1dd56f0e3dc62b1cc259122db36fc998c813776d677f3acf44c16a684ffda1082fc1f4f73e87cf5a96829b37fa47b1f2ca010aba85d82adf74eb7130c4d4ef53fa3938892ef424cfc95bfd276c2928f86903b7b845f7b57c9b95af823b3263d411ede092bbddc53138b199ba2f7f58c317390c5a1d3b943706c768efe8fd306f59d84d075dafdc074f24bb42a776fd4be4a472606f04d2c901cde7e083828801606663bfc74e59c926f26ad0e2505451f421ffeba7ef6133be520acebb0b22a31301a6cc0a6a2a5f241299e4819e225c4713a79ddbe1fcf634355761336bf3a3a70026000a7114e675d36640ff0df89c016c657d4701296c94f9bbaacc7572385e1a056f9511a2b18cfd6a773ee01defd63ea25c7ea5473c72a71b3f6a52b7a9819254d77951405cf9d42f6544e4c77ec3648cc47ac94810d108850f7a2d8c1ca827bd7c42d092627fbe6065ee7c61ad70aa64029c0e4211a91b19f4d007edaaae26da8f51308daec116b3396c89a7750e3426221cb8039e5f2f22820431816cf20c5c1650b93711c520b41981eba8507ce90fbdc9b9603c8cfbf4c0d8faa40a096cd43a7b3a48ab29a0a5e812d87b6990b0500e2732bbe8992d1dfe590a30f47d6966ae6558db19630ff3825f357f7bdcae02ec36a4df3ea5f14751d3fabda08062b5934e38fdb9dfbc5181663f17475debd527d867ffaf8a976f9cf383a7fb98ec2e70d4eb288de12a3b47907691cccae0f646d4c57aed99d835f109a33e23703aaa9bc92e9e11dfc6481b926ecd2e10d69f66bfe022fa623138786e4ff702ce1c6111b92815068efd923946d8b57cc99f339129a7cf872394360f16c5489a4d8ee7f9e1911b48b7275ab0076fed358991439a34cea606aff7ed88eab3fc54d0cb5c766083e6b39af5b11e34a100b2750cbc031dcb3047fc2310b0992a47e89d7a09870fed21b8c027d8c948034364907fb973d369c89ddef5590d2e5c907cb41e2f9e36bc43479180c119c397379192347bb3008406509d7e0ce8c874187ee9a6fedd150faceb93ebf7f2dcfc6f15acff65a930def663ab3a6856c54bf61aa380cfc9e97a9aea84d23a732b694759bdf8c602e6d28e9186e27e61d3538996b86de70972e75ce6add5e87f184f6e0f4dfd678a43378b3e62b45c51ebaebaf434ed79e3ac25ef4bb3685e2a0ddf30e311d396e70c7b7ab84a9c4941090badbdc3517a1e0390e7984d4d561536af2729d151b0995cc45a1b60cf02ce3dd789cb620558b83c1c78b8cefd33e2cc21962a3527950a2cefea375b4c86462839d153b551416a17dd0d523f6a29ea4a659fd8b7a9a8e0c8c54580e4765e0fc0512ae82d35b741692f692fd876b6f54aa6fda98f21f1643bb17123127687a44c392e4ea9a5eeb369f38b503db0bcf8ad22560011f91493c881a5f05059819fffe564c0a1c7a873a4994f81745e4bd9279a5ec0a01cffd871f0a0fd161dbb03a02953da066a21f82d83d3a7acfd9f37943aab6e27babe872f474a9953c259a38a29894ba1f46aef1888db89ca84c8ca08bf69c9c6a4450fc821a948056e97da613fb9d38a56dd42e744253f07600406f5362ba041389c5e3b5512d06d72037e0fbdc049441d11b44b495335760aab1ee556efbc876b25439226151d24dcd74bc89a065a4954889938415b7a2e406710f653b9abc5338fb94b16bcda96a7cc8890114dfd603ffa5ea071abb8d720c36f20564b6e4be4315f3528594e9051b46c559a4c13c027c36d95efffe96e11caa567a14e4166f3d902bcd7157005d0eed2efd793e7e008d6c4dac4058ebce9d350a7f6f07f7ecbec4b4c75da6ebae3c229d032ea8a68bce62dd9e045d9e16c8270a1c2c3b481c98f7616edd8872a172095fa012c96b2c8d56f00f6adf517c1b5d89e5f9255ea75b698a5659de7c4b375860d2a3409899661c6b506a9e3fd001c81b62298acf065f2b0080e5cba7cddfc6e6cb44f9c9610cd3588bfc6fd1a91bc9b20dad644703bcb6fc738cbec1d7602227b6da3dac9532f452e490dd6224aca11de17d69b8d16aa323d9cc8cabb41d935f2174dfa063c47b7893d65548ca72d73c1cf543e6d22aac8cf71c7aa8ba9a6bce4aa39085f508d6e6a537a1a61d58af074d');

String sum([Iterable<int>? data]) {
  return xxh128.convert(data?.toList() ?? []).hex(true);
}

String seedSum(int seed, [Iterable<int>? data]) {
  return XXH128.withSeed(seed).convert(data?.toList() ?? []).hex(true);
}

void main() {
  group('XXH3-128 test', () {
    test("with seed = 0, length = 0", () {
      expect(sum(), "F16110CE5B54171FE16A918E964EFD07");
    });
    test("with seed = $seed, length = 0", () {
      expect(seedSum(seed), "AC517D3831E68272E6B91A13A8B04387");
    });
    test("with seed = 0, length = 1", () {
      expect(sum(cases.take(1)), "C501CB24AEEB36B9051AA76357B05425");
    });
    test("with seed = $seed, length = 1", () {
      expect(seedSum(seed, cases.take(1)), "B8454BC028C657CAF91CD2DCF4316891");
    });
    test("with seed = 0, length = 6", () {
      expect(sum(cases.take(6)), "C6CF43DABD39703E2AD162810BFE2A08");
    });
    test("with seed = $seed, length = 6", () {
      expect(seedSum(seed, cases.take(6)), "6E8598BE708F9D26B1D2AB89535B865A");
    });
    test("with seed = 0, length = 12", () {
      expect(sum(cases.take(12)), "D99AF61327191A06182B80C78FFD3E6E");
    });
    test("with seed = $seed, length = 12", () {
      expect(seedSum(seed, cases.take(12)), "FB7D3C7FA6F9E99BD305348A519DE0D7");
    });
    test("with seed = 0, length = 24", () {
      expect(sum(cases.take(24)), "1D901B8BD244701E61378D67E466E90C");
    });
    test("with seed = $seed, length = 24", () {
      expect(seedSum(seed, cases.take(24)), "A940ADEB544C30D743A2A61467026231");
    });
    test("with seed = 0, length = 48", () {
      expect(sum(cases.take(48)), "7BF680ED9A2142F97E2278544EAC02A0");
    });
    test("with seed = $seed, length = 48", () {
      expect(seedSum(seed, cases.take(48)), "4E93A153E4C3A37B9522076CE3DD3A16");
    });
    test("with seed = 0, length = 81", () {
      expect(sum(cases.take(81)), "03B85FF9B9AF8B5E4200AB8181F55249");
    });
    test("with seed = $seed, length = 81", () {
      expect(seedSum(seed, cases.take(81)), "5C755F7A3DBB3F70B60F75DC7AEC2427");
    });
    test("with seed = 0, length = 222", () {
      expect(sum(cases.take(222)), "3A6BEC7C59BDAEF11787941B64097E33");
    });
    test("with seed = $seed, length = 222", () {
      expect(
          seedSum(seed, cases.take(222)), "8D7A91AFB85B99AEF1971E6216008291");
    });
    test("with seed = 0, length = 403", () {
      expect(sum(cases.take(403)), "A4DEC6654D80EBCD3DD72D331EE26D1B");
    });
    test("with seed = $seed, length = 403", () {
      expect(
          seedSum(seed64, cases.take(403)), "FD4364FDECF65962F2E80B1E9711D3BE");
    });
    test("with seed = 0, length = 512", () {
      expect(sum(cases.take(512)), "67E3BE3E15B84314972987CD487EEC98");
    });
    test("with seed = $seed, length = 512", () {
      expect(
          seedSum(seed64, cases.take(512)), "F2F1523A82C6FD43F01E4E194F8A742F");
    });
    test("with seed = 0, length = 2048", () {
      expect(sum(cases.take(2048)), "23068EBE018525F4205B757A26A23069");
    });
    test("with seed = $seed, length = 2048", () {
      expect(
          seedSum(seed, cases.take(2048)), "ACD90AFAC256CC1092D8F2EEC2A3D7D0");
    });
    test("with seed = 0, length = 2240", () {
      expect(sum(cases.take(2240)), "7E4AB8CB7AAE9058627EAA77B327C385");
    });
    test("with seed = $seed, length = 2240", () {
      expect(
          seedSum(seed, cases.take(2240)), "AAD2CBDC726D5E20355207DB1402B762");
    });
    test("with seed = 0, length = 2237", () {
      expect(sum(cases.take(2237)), "CCD93C76A1CE03F471B3983C3FBFDA0C");
    });
    test("with seed = $seed, length = 2237", () {
      expect(
          seedSum(seed, cases.take(2237)), "51880146E44E82F3C553BD6417751BC8");
    });
  }, tags: 'skip-js');
}
