import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

enum CardStatus { keep, remove }

class CardProvider extends ChangeNotifier {
  List<AssetEntity> _entities = [];
  final List<CardStatus> _timeline = [];
  final List<AssetEntity> _keepItems = [];
  final List<AssetEntity> _removeItems = [];
  Offset _position = Offset.zero;
  bool _isDragging = false;
  Size _screenSize = Size.zero;
  double _angle = 0;
  final int _perGetPhotoNum = 3;
  int _photoStart = 0;
  int _totalPhotoCount = 0;
  int _totalPhotoGetCount = 0;
  PermissionState? _permissionState;
  
  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;
  List<AssetEntity> get entities => _entities;
  List<CardStatus> get timeline => _timeline;
  int get deleteNum => _removeItems.length;
  int get perGetPhotoNum => _perGetPhotoNum;
  int get photoStart => _photoStart;
  int get totalPhotoCount => _totalPhotoCount;
  int get totalPhotoGetCount => _totalPhotoGetCount;
  PermissionState? get permissionState => _permissionState;

  void setPermissionState(PermissionState permissionState) {
    _permissionState = permissionState;
    notifyListeners();
  }

  void setTotalPhotoGetCount(int total) {
    _totalPhotoGetCount += total;
  }

  void setTotalPhotoCount(int total) {
    _totalPhotoCount = total;
  }

  void setPhotoStart(int num) {
    _photoStart = num;
  }

  void addResult(CardStatus status, AssetEntity entity) {
    switch(status) {
      case CardStatus.keep:
        _keepItems.insert(0, entity);
        break;
      case CardStatus.remove:
        _removeItems.insert(0, entity);
        break;
      default:
    }
  }

  void addTimeline(CardStatus status) {
    _timeline.insert(0, status);
  }

  void setScreenSize(Size screenSize) {
    _screenSize = screenSize;
  }

  void addAssets(List<AssetEntity> entities) {
    _entities.insertAll(0, entities);
  }

  void setAssets(List<AssetEntity> entities) {
    _entities = entities;

    notifyListeners();
  }

  void setAsset(AssetEntity entity) {
    _entities.add(entity);
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition(DragEndDetails details) {
    _isDragging = false;

    final status = getStatus(force: true);

    switch(status) {
      case CardStatus.keep:
        keep();
        break;
      case CardStatus.remove:
        remove();
        break;
      default:
        resetPosition();
    }

    notifyListeners();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({ bool force = false }) {
    final x = _position.dx;
    
    final delta = force ? 100 : 20;

    if (x >= delta) {
      return CardStatus.keep;
    }

    if (x <= -delta) {
      return CardStatus.remove;
    }
    return null;
  }

  void getNewPhotos() async {
    if (_totalPhotoGetCount >= _totalPhotoCount) return;

    setPhotoStart(_photoStart + _perGetPhotoNum);

    final List<AssetEntity> entities = await PhotoManager.getAssetListRange(
      start: _photoStart,
      end: _photoStart + _perGetPhotoNum,
    );

    setTotalPhotoGetCount(entities.length);

    // Filter asset type is not image
    entities.removeWhere((element) => element.type != AssetType.image);

    addAssets(entities.reversed.toList());
  }

  void keep() {
    if (entities.isEmpty) {
      return;
    }

    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);

    addResult(CardStatus.keep, entities.last);
    addTimeline(CardStatus.keep);
    nextCard();
    getNewPhotos();

    notifyListeners();
  }

  void remove() async {
    if (entities.isEmpty) {
      return;
    }
    
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);

    addResult(CardStatus.remove, entities.last);
    addTimeline(CardStatus.remove);
    nextCard();
    getNewPhotos();

    notifyListeners();
  }

  void deletePhoto() async {
    if (_timeline.isEmpty || _removeItems.isEmpty) {
      return;
    }

    final List<String> removeIds = _removeItems.map((element) => element.id).toList();

    final result = await PhotoManager.editor.deleteWithIds(
      <String>[...removeIds],
    );

    if (result.isEmpty) {
      return;
    }

    _removeItems.clear();
    notifyListeners();
  }

  void undo() async {
    if (_timeline.isEmpty) {
      return;
    }

    final CardStatus status = timeline[0];

    AssetEntity? undoEntity;

    switch(status) {
      case CardStatus.keep:
        if (_keepItems.isEmpty) {
          return;
        }
        undoEntity = _keepItems[0];
        break;
      case CardStatus.remove:
        if (_removeItems.isEmpty) {
          return;
        }
        undoEntity = _removeItems[0];
        break;
      default:
    }

    if (undoEntity == null) {
      return;
    }

    if (status == CardStatus.keep) {
      _angle = 20;
      _position += Offset(2 * _screenSize.width, 0);
    } else {
      _angle = -20;
      _position -= Offset(2 * _screenSize.width, 0);
    }

    setAsset(undoEntity);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    switch(status) {
      case CardStatus.keep:
        _keepItems.removeAt(0);
        break;
      case CardStatus.remove:
        _removeItems.removeAt(0);
        break;
      default:
    }

    _timeline.removeAt(0);

    resetPosition();
  }

  Future nextCard() async {
    if (_entities.isEmpty) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    _entities.removeLast();

    resetPosition();
  }
}