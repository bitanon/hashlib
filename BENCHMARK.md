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
    <td><code>████████████████</code> <br> <small><b>1.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>290 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>915 Mbps &#128315;1.88x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>864 Mbps &#128315;1.89x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>169 Mbps &#128315;1.72x</small></td>
  </tr>
  <tr>
    <td rowspan="4">MD5</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.45 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.35 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>236 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>1.36 Gbps &#128315;1.07x</small></td>
    <td><code>███████████████░</code> <br> <small>1.29 Gbps &#128315;1.05x</small></td>
    <td><code>███████████████░</code> <br> <small>228 Mbps &#128315;1.04x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>920 Mbps &#128315;1.58x</small></td>
    <td><code>███████████░░░░░</code> <br> <small>929 Mbps &#128315;1.45x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>78.66 Mbps &#128315;3x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████████░░░░░░░</code> <br> <small>775 Mbps &#128315;1.88x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>729 Mbps &#128315;1.85x</small></td>
    <td><code>██████████░░░░░░</code> <br> <small>141 Mbps &#128315;1.68x</small></td>
  </tr>
  <tr>
    <td rowspan="3">HMAC(MD5)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.45 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.1 Gbps</b> &#127775;</small></td>
    <td><code>████████████░░░░</code> <br> <small>44.14 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>1.34 Gbps &#128315;1.08x</small></td>
    <td><code>████████████████</code> <br> <small>1.1 Gbps &#128315;1x</small></td>
    <td><code>████████████████</code> <br> <small><b>58.31 Mbps</b> &#128314;1.32x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>913 Mbps &#128315;1.59x</small></td>
    <td><code>██████████░░░░░░</code> <br> <small>681 Mbps &#128315;1.61x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>20.71 Mbps &#128315;2.13x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-1</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.27 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.17 Gbps</b> &#127775;</small></td>
    <td><code>██████████████░░</code> <br> <small>155 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.12 Gbps &#128315;1.14x</small></td>
    <td><code>███████████████░</code> <br> <small>1.07 Gbps &#128315;1.08x</small></td>
    <td><code>████████████████</code> <br> <small><b>172 Mbps</b> &#128314;1.11x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>502 Mbps &#128315;2.53x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>472 Mbps &#128315;2.47x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>76.54 Mbps &#128315;2.03x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>544 Mbps &#128315;2.34x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>534 Mbps &#128315;2.18x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>56.57 Mbps &#128315;2.74x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-1)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.27 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>804 Mbps </small></td>
    <td><code>█████████████░░░</code> <br> <small>21.87 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.13 Gbps &#128315;1.13x</small></td>
    <td><code>████████████████</code> <br> <small><b>818 Mbps</b> &#128314;1.02x</small></td>
    <td><code>████████████████</code> <br> <small><b>26.98 Mbps</b> &#128314;1.23x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>934 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>126 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>932 Mbps &#128315;1.1x</small></td>
    <td><code>███████████████░</code> <br> <small>878 Mbps &#128315;1.06x</small></td>
    <td><code>████████████████</code> <br> <small><b>128 Mbps</b> &#128314;1.01x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>224 Mbps &#128315;4.57x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>231 Mbps &#128315;4.04x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>31.13 Mbps &#128315;4.05x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>233 Mbps &#128315;4.39x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>222 Mbps &#128315;4.2x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>37.18 Mbps &#128315;3.39x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>945 Mbps</b> &#127775;</small></td>
    <td><code>███████████████░</code> <br> <small>124 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>929 Mbps &#128315;1.1x</small></td>
    <td><code>███████████████░</code> <br> <small>891 Mbps &#128315;1.06x</small></td>
    <td><code>████████████████</code> <br> <small><b>129 Mbps</b> &#128314;1.04x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>239 Mbps &#128315;4.26x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>234 Mbps &#128315;4.04x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>30.82 Mbps &#128315;4.03x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>237 Mbps &#128315;4.31x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>220 Mbps &#128315;4.3x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>36.1 Mbps &#128315;3.44x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-256)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>652 Mbps</b> &#127775;</small></td>
    <td><code>██████████████░░</code> <br> <small>17.89 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>943 Mbps &#128315;1.09x</small></td>
    <td><code>████████████████</code> <br> <small>649 Mbps &#128315;1x</small></td>
    <td><code>████████████████</code> <br> <small><b>20.79 Mbps</b> &#128314;1.16x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.97 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>107 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>654 Mbps &#128315;3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>565 Mbps &#128315;2.9x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>48.35 Mbps &#128315;2.22x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>175 Mbps &#128315;11.26x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>166 Mbps &#128315;9.85x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>14.86 Mbps &#128315;7.23x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>51.87 Mbps &#128315;37.9x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>45.78 Mbps &#128315;35.79x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.98 Mbps &#128315;26.98x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.95 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>108 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>638 Mbps &#128315;3.06x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>561 Mbps &#128315;2.93x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>47.21 Mbps &#128315;2.29x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>168 Mbps &#128315;11.62x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>164 Mbps &#128315;10.02x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>15 Mbps &#128315;7.2x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>52.45 Mbps &#128315;37.17x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>46.35 Mbps &#128315;35.45x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.9 Mbps &#128315;27.68x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.01 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>948 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>126 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>33.09 Mbps &#128315;30.62x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>29.38 Mbps &#128315;32.26x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.25 Mbps &#128315;56.26x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>936 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>126 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>31.04 Mbps &#128315;33.01x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>29.19 Mbps &#128315;32.08x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.25 Mbps &#128315;55.97x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.96 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>109 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>23.66 Mbps &#128315;82.75x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>23.29 Mbps &#128315;69.91x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.25 Mbps &#128315;48.21x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.95 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>108 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>16.29 Mbps &#128315;119.52x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>15.27 Mbps &#128315;107.63x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.27 Mbps &#128315;47.74x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.38 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.29 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>203 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>478 Mbps &#128315;2.89x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>448 Mbps &#128315;2.87x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>80.7 Mbps &#128315;2.52x</small></td>
  </tr>
  <tr>
    <td rowspan="3">RIPEMD-160</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>734 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>700 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>110 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████████░░░░░░░░</code> <br> <small>366 Mbps &#128315;2.01x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>358 Mbps &#128315;1.96x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>45.18 Mbps &#128315;2.44x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>333 Mbps &#128315;2.2x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>316 Mbps &#128315;2.21x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>54.44 Mbps &#128315;2.03x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.56 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.44 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>217 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>471 Mbps &#128315;3.31x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>436 Mbps &#128315;3.3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>76.01 Mbps &#128315;2.86x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-320</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>708 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>679 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>107 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>337 Mbps &#128315;2.1x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>318 Mbps &#128315;2.14x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>52.8 Mbps &#128315;2.02x</small></td>
  </tr>
  <tr>
    <td>BLAKE-2s</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.67 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.65 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>208 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">BLAKE-2b</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>2.08 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>2.07 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>180 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>120 Mbps &#128315;17.33x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>119 Mbps &#128315;17.43x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>9.25 Mbps &#128315;19.5x</small></td>
  </tr>
  <tr>
    <td rowspan="2">Poly1305</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>4.61 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>4.48 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>680 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.29 Gbps &#128315;3.57x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.24 Gbps &#128315;3.62x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>349 Mbps &#128315;1.95x</small></td>
  </tr>
  <tr>
    <td>XXH32</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>6 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>5.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>855 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH64</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>3.53 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>3.05 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>699 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.44 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.23 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>77.31 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.43 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.24 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>76.51 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">SM3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>955 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>885 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>142 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>245 Mbps &#128315;3.89x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>228 Mbps &#128315;3.88x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>37.45 Mbps &#128315;3.8x</small></td>
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
    <td>1.02 ms</td>
    <td>11.11 ms</td>
    <td>61.04 ms</td>
    <td>2007.44 ms</td>
  </tr>
  <tr>
    <td>bcrypt</td>
    <td>2.63 ms</td>
    <td>20.57 ms</td>
    <td>328.42 ms</td>
    <td>2606.94 ms</td>
  </tr>
  <tr>
    <td>pbkdf2</td>
    <td>0.43 ms</td>
    <td>13.96 ms</td>
    <td>232.34 ms</td>
    <td>2809.76 ms</td>
  </tr>
  <tr>
    <td>argon2i</td>
    <td>2.13 ms</td>
    <td>14.69 ms</td>
    <td>193.6 ms</td>
    <td>2070.51 ms</td>
  </tr>
  <tr>
    <td>argon2d</td>
    <td>2.03 ms</td>
    <td>14.54 ms</td>
    <td>191.72 ms</td>
    <td>2069.29 ms</td>
  </tr>
  <tr>
    <td>argon2id</td>
    <td>2.05 ms</td>
    <td>14.52 ms</td>
    <td>191.36 ms</td>
    <td>2063.43 ms</td>
  </tr>
</tbody>
</table>

> All benchmarks are done on 36GB _Apple M3 Pro_ using compiled _exe_
>
> Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "macos_arm64"
