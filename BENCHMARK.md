## Benchmarks

### Libraries

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

### Hash Functions

<table>
<thead>
  <tr>
    <th>Algorithm</th>
    <th>Library</th>
    <th>5MB message</th>
    <th>1KB message</th>
    <th>10B message</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="2">MD4</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.72 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>285 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>888 Mbps &#128315;1.94x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>846 Mbps &#128315;1.94x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>163 Mbps &#128315;1.75x</small></td>
  </tr>
  <tr>
    <td rowspan="4">MD5</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.47 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.32 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>216 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>1.38 Gbps &#128315;1.06x</small></td>
    <td><code>████████████████</code> <br> <small>1.29 Gbps &#128315;1.03x</small></td>
    <td><code>███████████████░</code> <br> <small>205 Mbps &#128315;1.05x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>952 Mbps &#128315;1.55x</small></td>
    <td><code>███████████░░░░░</code> <br> <small>904 Mbps &#128315;1.47x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>69.73 Mbps &#128315;3.1x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>737 Mbps &#128315;2x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>705 Mbps &#128315;1.88x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>125 Mbps &#128315;1.73x</small></td>
  </tr>
  <tr>
    <td rowspan="3">HMAC(MD5)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.4 Gbps</b> &#127775;</small></td>
    <td><code>██████████████░░</code> <br> <small>987 Mbps </small></td>
    <td><code>████████████░░░░</code> <br> <small>43.81 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>████████████████</code> <br> <small>1.37 Gbps &#128315;1.02x</small></td>
    <td><code>████████████████</code> <br> <small><b>1.1 Gbps</b> &#128314;1.12x</small></td>
    <td><code>████████████████</code> <br> <small><b>56.83 Mbps</b> &#128314;1.3x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>898 Mbps &#128315;1.56x</small></td>
    <td><code>██████████░░░░░░</code> <br> <small>666 Mbps &#128315;1.48x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>19.44 Mbps &#128315;2.25x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-1</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.26 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.16 Gbps</b> &#127775;</small></td>
    <td><code>███████████████░</code> <br> <small>153 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.11 Gbps &#128315;1.13x</small></td>
    <td><code>███████████████░</code> <br> <small>1.08 Gbps &#128315;1.07x</small></td>
    <td><code>████████████████</code> <br> <small><b>167 Mbps</b> &#128314;1.09x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>478 Mbps &#128315;2.64x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>464 Mbps &#128315;2.49x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>75.97 Mbps &#128315;2.01x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>533 Mbps &#128315;2.36x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>524 Mbps &#128315;2.21x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>54 Mbps &#128315;2.83x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-1)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.27 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>805 Mbps </small></td>
    <td><code>█████████████░░░</code> <br> <small>21.93 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.11 Gbps &#128315;1.15x</small></td>
    <td><code>████████████████</code> <br> <small><b>812 Mbps</b> &#128314;1.01x</small></td>
    <td><code>████████████████</code> <br> <small><b>26.82 Mbps</b> &#128314;1.22x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>868 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>120 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>913 Mbps &#128315;1.12x</small></td>
    <td><code>███████████████░</code> <br> <small>838 Mbps &#128315;1.04x</small></td>
    <td><code>████████████████</code> <br> <small>118 Mbps &#128315;1.01x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>245 Mbps &#128315;4.19x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>228 Mbps &#128315;3.81x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>29.68 Mbps &#128315;4.05x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███░░░░░░░░░░░░░</code> <br> <small>219 Mbps &#128315;4.68x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>222 Mbps &#128315;3.91x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>36.69 Mbps &#128315;3.27x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>941 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>121 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>944 Mbps &#128315;1.09x</small></td>
    <td><code>███████████████░</code> <br> <small>864 Mbps &#128315;1.09x</small></td>
    <td><code>████████████████</code> <br> <small><b>123 Mbps</b> &#128314;1.02x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>243 Mbps &#128315;4.22x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>224 Mbps &#128315;4.21x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>30.65 Mbps &#128315;3.94x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>235 Mbps &#128315;4.36x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>220 Mbps &#128315;4.28x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>36.27 Mbps &#128315;3.33x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-256)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.04 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>651 Mbps </small></td>
    <td><code>██████████████░░</code> <br> <small>17.88 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>942 Mbps &#128315;1.1x</small></td>
    <td><code>████████████████</code> <br> <small><b>651 Mbps</b> &#128314;1x</small></td>
    <td><code>████████████████</code> <br> <small><b>20.2 Mbps</b> &#128314;1.13x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.96 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.65 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>105 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>654 Mbps &#128315;3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>591 Mbps &#128315;2.8x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>51.35 Mbps &#128315;2.05x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>172 Mbps &#128315;11.43x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>161 Mbps &#128315;10.27x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>14.32 Mbps &#128315;7.36x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>50.49 Mbps &#128315;38.88x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>44.81 Mbps &#128315;36.9x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.86 Mbps &#128315;27.28x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.97 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>102 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>655 Mbps &#128315;3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>590 Mbps &#128315;2.78x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>50.24 Mbps &#128315;2.04x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>173 Mbps &#128315;11.36x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>160 Mbps &#128315;10.23x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>14.37 Mbps &#128315;7.13x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>49.25 Mbps &#128315;39.91x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>43.61 Mbps &#128315;37.58x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.75 Mbps &#128315;27.33x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>913 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>116 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>31.33 Mbps &#128315;32.73x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>27.45 Mbps &#128315;33.25x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.13 Mbps &#128315;54.28x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>941 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>120 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>29.91 Mbps &#128315;34.28x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>27.96 Mbps &#128315;33.67x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.14 Mbps &#128315;56.1x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.94 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.65 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>104 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>22.7 Mbps &#128315;85.4x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>22.47 Mbps &#128315;73.34x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.16 Mbps &#128315;47.82x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.91 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>101 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>15.8 Mbps &#128315;121.05x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.79 Mbps &#128315;110.1x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.14 Mbps &#128315;47.04x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.41 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.33 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>195 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>462 Mbps &#128315;3.05x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>438 Mbps &#128315;3.03x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>78.39 Mbps &#128315;2.48x</small></td>
  </tr>
  <tr>
    <td rowspan="3">RIPEMD-160</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>743 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>698 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>108 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████████░░░░░░░░</code> <br> <small>373 Mbps &#128315;1.99x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>359 Mbps &#128315;1.95x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>43.29 Mbps &#128315;2.48x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>335 Mbps &#128315;2.22x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>317 Mbps &#128315;2.2x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>54.48 Mbps &#128315;1.97x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.56 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.44 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>220 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>468 Mbps &#128315;3.33x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>440 Mbps &#128315;3.29x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>74.18 Mbps &#128315;2.97x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-320</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>713 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>669 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>105 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>331 Mbps &#128315;2.15x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>314 Mbps &#128315;2.13x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>51.56 Mbps &#128315;2.03x</small></td>
  </tr>
  <tr>
    <td>BLAKE-2s</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.69 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.67 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>203 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">BLAKE-2b</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>2.06 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>2.07 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>181 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>120 Mbps &#128315;17.09x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>119 Mbps &#128315;17.45x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>9.26 Mbps &#128315;19.56x</small></td>
  </tr>
  <tr>
    <td rowspan="2">Poly1305</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>4.59 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>4.48 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>595 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.18 Gbps &#128315;3.88x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.16 Gbps &#128315;3.87x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>310 Mbps &#128315;1.92x</small></td>
  </tr>
  <tr>
    <td>XXH32</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>5.9 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>5.6 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>789 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH64</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>3.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>3.3 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>639 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.46 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.23 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>70.49 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.43 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.21 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>68.5 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">SM3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>947 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>862 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>136 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>241 Mbps &#128315;3.93x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>228 Mbps &#128315;3.78x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>37.31 Mbps &#128315;3.65x</small></td>
  </tr>
</tbody>
</table>

### Key Derivators

<table>
<thead>
  <tr>
    <th>Algorithm</th>
    <th>little</th>
    <th>moderate</th>
    <th>good</th>
    <th>strong</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>scrypt</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>1.01 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>11.21 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>61.03 ms</small></td>
    <td><code>████████████████</code> <br> <small>2033.95 ms</small></td>
  </tr>
  <tr>
    <td>bcrypt</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.7 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>20.6 ms</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>331.8 ms</small></td>
    <td><code>████████████████</code> <br> <small>2650.52 ms</small></td>
  </tr>
  <tr>
    <td>pbkdf2</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>0.42 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.05 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>232.89 ms</small></td>
    <td><code>████████████████</code> <br> <small>2777.65 ms</small></td>
  </tr>
  <tr>
    <td>argon2i</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.37 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.86 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>192.95 ms</small></td>
    <td><code>████████████████</code> <br> <small>2087.93 ms</small></td>
  </tr>
  <tr>
    <td>argon2d</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.14 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>15.01 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>191.21 ms</small></td>
    <td><code>████████████████</code> <br> <small>2094.69 ms</small></td>
  </tr>
  <tr>
    <td>argon2id</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.11 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.68 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>192.04 ms</small></td>
    <td><code>████████████████</code> <br> <small>2052.91 ms</small></td>
  </tr>
</tbody>
</table>

> All benchmarks are done on 36GB _Apple M3 Pro_ using compiled _exe_
>
> Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "macos_arm64"
