import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:kira_auth/models/export.dart';
import 'package:kira_auth/config.dart';
import 'package:kira_auth/services/export.dart';
import 'package:kira_auth/utils/cache.dart';

class NetworkService {
  List<Validator> validators = [];
  List<Block> blocks = [];
  Block block;
  List<Transaction> transactions = [];
  int latestBlockHeight = 0;

  Future<void> getValidators({ bool includesDummy = false }) async {
    List<Validator> validatorList = [];

    String apiUrl = await loadInterxURL();
    var data = await http.get(apiUrl + "/valopers");

    var bodyData = json.decode(data.body);
    var validators = bodyData['validators'];

    for (int i = 0; i < validators.length; i++) {
      Validator validator = Validator(
        address: validators[i]['address'],
        valkey: validators[i]['valkey'],
        pubkey: validators[i]['pubkey'],
        moniker: validators[i]['moniker'],
        website: validators[i]['website'] ?? "",
        social: validators[i]['social'] ?? "",
        identity: validators[i]['identity'] ?? "",
        commission: double.parse(validators[i]['commission'] ?? "0"),
        status: validators[i]['status'],
        rank: validators[i]['rank'] ?? 0,
        streak: validators[i]['streak'] ?? 0,
        mischance: validators[i]['mischance'] ?? 0,
      );
      validatorList.add(validator);
    }

    if (includesDummy) {
      validatorList.add(Validator(
        address: "kira1tuv9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1tuv9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "test 3",
        website: "",
        social: "social",
        identity: "",
        commission: 0.0003462,
        status: "ACTIVE",
        rank: 5,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1wer9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1wer9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "kira",
        website: "",
        social: "social",
        identity: "",
        commission: 0.2626723,
        status: "INACTIVE",
        rank: 6,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1oij9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1oij9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "ongoing",
        website: "",
        social: "social",
        identity: "",
        commission: 0.2357255234,
        status: "UNDEFINED",
        rank: 9,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1aps9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1aps9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "total",
        website: "",
        social: "social",
        identity: "",
        commission: 0.0000346234,
        status: "PAUSED",
        rank: 3,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1gow9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1gow9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "network",
        website: "",
        social: "social",
        identity: "",
        commission: 0.94674,
        status: "INACTIVE",
        rank: 8,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1pip9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1pip9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "knife",
        website: "",
        social: "social",
        identity: "",
        commission: 0.54672346,
        status: "PAUSED",
        rank: 1,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1bwc9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1bwc9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "moon",
        website: "",
        social: "social",
        identity: "",
        commission: 0.116346,
        status: "ACTIVE",
        rank: 2,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1wfw9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1wfw9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "testnet",
        website: "",
        social: "social",
        identity: "",
        commission: 0.88256,
        status: "ACTIVE",
        rank: 7,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1gwn9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1gwn9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "everyone",
        website: "",
        social: "social",
        identity: "",
        commission: 0.14367782345,
        status: "UNDEFINED",
        rank: 4,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1qqx9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1qqx9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "guy",
        website: "",
        social: "social",
        identity: "",
        commission: 0.098593556345,
        status: "INACTIVE",
        rank: 15,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1vop9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1vop9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "working",
        website: "",
        social: "social",
        identity: "",
        commission: 0.8654634,
        status: "INACTIVE",
        rank: 12,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1mkf9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1mkf9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "last",
        website: "",
        social: "social",
        identity: "",
        commission: 0.6623454532,
        status: "ACTIVE",
        rank: 14,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1ntr9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1ntr9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "middle",
        website: "",
        social: "social",
        identity: "",
        commission: 0.1534667,
        status: "PAUSED",
        rank: 11,
        streak: 1,
        mischance: 1
      ));
      validatorList.add(Validator(
        address: "kira1lwty9pcmlnywlpphj8vtm0j0alhrrjwjsdxmjts",
        valkey: "kiravaloper1lwty9pcmlnywlpphj8vtm0j0alhrrjwjs7q83nu",
        pubkey: "kiravalconspub1zcjduepqm98ffgul4ppzzur6l67v3mj2vsyc7tr9nrzwk3e0ffx0z7l9sgsqnln467",
        moniker: "confirm",
        website: "",
        social: "social",
        identity: "",
        commission: 0.445235235,
        status: "ACTIVE",
        rank: 13,
        streak: 1,
        mischance: 1
      ));
    }

    validatorList.sort((a, b) => a.rank.compareTo(b.rank));
    this.validators = validatorList;
  }

  Future<void> getBlocks() async {
    List<Block> blockList = [];

    var statusService = StatusService();
    await statusService.getNodeStatus();
    var latestHeight = int.parse(statusService.syncInfo.latestBlockHeight);
    var minHeight = max(latestBlockHeight, latestHeight - 10);
    latestBlockHeight = latestHeight;
    String apiUrl = await loadInterxURL();
    var data = await http.get(apiUrl + '/cosmos/blocks?minHeight=${minHeight + 1}&maxHeight=$latestHeight');

    var bodyData = json.decode(data.body);
    var blocks = bodyData['block_metas'];

    for (int i = 0; i < blocks.length; i++) {
      var header = blocks[i]['header'];
      Block block = Block(
        blockSize: int.parse(blocks[i]['block_size']),
        txAmount: int.parse(blocks[i]['num_txs']),
        appHash: header['app_hash'],
        chainId: header['chain_id'],
        consensusHash: header['consensus_hash'],
        dataHash: header['data_hash'],
        evidenceHash: header['evidence_hash'],
        height: int.parse(header['height']),
        lastCommitHash: header['last_commit_hash'],
        lastResultsHash: header['last_results_hash'],
        nextValidatorsHash: header['next_validators_hash'],
        proposerAddress: header['proposer_address'],
        validatorsHash: header['validators_hash'],
        time: DateTime.parse(header['time'] ?? DateTime.now().toString()).toUtc(),
      );
      blockList.add(block);
    }

    this.blocks = blockList;
  }

  Future<void> searchBlock(String query, bool isHash) async {
    if (isHash) {
      String apiUrl = await loadSekaiURL();
      var data = await http.get(apiUrl + '/block_by_hash?hash=$query');
      var bodyData = json.decode(data.body) as Map<String, dynamic>;
      block = null;
      if (!bodyData.containsKey("result")) return;
      var blockData = bodyData["result"];
      if (blockData == null) return;
      var header = blockData['header'];
      block = Block(
        blockSize: 1,
        txAmount: (blockData['data'] as List).length,
        appHash: header['app_hash'],
        chainId: header['chain_id'],
        consensusHash: header['consensus_hash'],
        dataHash: header['data_hash'],
        evidenceHash: header['evidence_hash'],
        height: int.parse(header['height']),
        lastCommitHash: header['last_commit_hash'],
        lastResultsHash: header['last_results_hash'],
        nextValidatorsHash: header['next_validators_hash'],
        proposerAddress: header['proposer_address'],
        validatorsHash: header['validators_hash'],
        time: DateTime.parse(header['time'] ?? DateTime.now().toString()).toUtc(),
      );
    } else {
      String apiUrl = await loadInterxURL();
      var data = await http.get(apiUrl + '/cosmos/blocks/${int.parse(query)}');
      var bodyData = json.decode(data.body);
      var txAmount = (bodyData['block']['data']['txs'] as List).length;

      var header = bodyData['data']['header'];
      block = Block(
        blockSize: 1,
        txAmount: txAmount,
        appHash: header['app_hash'],
        chainId: header['chain_id'],
        consensusHash: header['consensus_hash'],
        dataHash: header['data_hash'],
        evidenceHash: header['evidence_hash'],
        height: int.parse(header['height']),
        lastCommitHash: header['last_commit_hash'],
        lastResultsHash: header['last_results_hash'],
        nextValidatorsHash: header['next_validators_hash'],
        proposerAddress: header['proposer_address'],
        validatorsHash: header['validators_hash'],
        time: DateTime.parse(header['time'] ?? DateTime.now().toString()).toUtc(),
      );
    }
  }

  Future<void> getTransactions(int height) async {
    if (await checkTransactionsExists(height)) {
      this.transactions = await getTransactionsForHeight(height);
    } else {
      this.transactions = TransactionService().getDummyWithdrawalTransactions();
    }
  }
}
