//
//  GameViewController.swift
//  SceneKitAnimation
//
//  Created by Matsuoka Masahiro on 2020/06/21.
//  Copyright © 2020 Matsuoka Masahiro. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    /// オブジェクト追加用のルートノード
    let rootNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create a new scene
        let scene = SCNScene()

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // シーンにルートノードを追加する
        scene.rootNode.addChildNode(rootNode)


        // retrieve the SCNView
        let scnView = self.view as! SCNView

        /* デバッグ用設定 */
        // 背景を灰色に設定する
        scnView.backgroundColor = UIColor.gray
        // 現在の視点をユーザーが操作できるように設定
        scnView.allowsCameraControl = true
        // レンダリングパフォーマンス統計を表示する
        scnView.showsStatistics = true
        scnView.debugOptions = [
            .showBoundingBoxes, // オブジェクトのバウンディングボックスを表示する
            .showWireframe, // ワイヤーフレームを表示する
            .showCameras, // 仮想カメラを表示する
        ]

        // set the scene to the view
        scnView.scene = scene

        // 原点を追加する
        rootNode.addChildNode(makeOriginNode())

        // 座標軸を追加する
        rootNode.addChildNode(makeAxisNode())
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}

/// 追加するオブジェクト
extension GameViewController {

    /// 原点を作成する
    func makeOriginNode() -> SCNNode {
        let sphere = makeSphereNode(radius: 0.25)
        sphere.position = SCNVector3(0, 0, 0)
        return sphere
    }

    /// スフィア(球体)ノードを追加する
    func makeSphereNode(radius: CGFloat = 1.0) -> SCNNode {
        let sphere: SCNGeometry = SCNSphere(radius: radius)
        let sphereNode = SCNNode(geometry: sphere)
        return sphereNode
    }

    /// 座標軸ノードを作成する
    func makeAxisNode() -> SCNNode {
        let node = SCNNode()
        node.name = "asix"

        // x軸
        node.addChildNode(makeXAxisNode())
        // y軸
        node.addChildNode(makeYAxisNode())
        // z軸
        node.addChildNode(makeZAxisNode())

        return node
    }

    /// x軸ノードを作成する
    func makeXAxisNode(radius: CGFloat = 0.1, height: CGFloat = 5.0, color: UIColor = .red) -> SCNNode {
        let cylinderNode = makeCylinderNode(radius: radius, height: height, color: color)
        // z軸を基準に90度(0.5π)回転する
        cylinderNode.simdRotate(
            by: simd_quatf(
                angle: .pi * 0.5, // 回転角
                axis: simd_normalize(simd_float3(0, 0, 1)) // 回転軸
            ),
            aroundTarget: simd_float3(0, 0, 0)
        )
        // 原点まで移動する
        cylinderNode.position = SCNVector3(height * 0.5, 0, 0)
        return cylinderNode
    }

    /// y軸ノードを作成する
    func makeYAxisNode(radius: CGFloat = 0.1, height: CGFloat = 5.0, color: UIColor = .green) -> SCNNode {
        let cylinderNode = makeCylinderNode(radius: radius, height: height, color: color)
        // 原点まで移動する
        cylinderNode.position = SCNVector3(0, height * 0.5, 0)
        return cylinderNode
    }

    /// z軸ノードを作成する
    func makeZAxisNode(radius: CGFloat = 0.1, height: CGFloat = 5.0, color: UIColor = .blue) -> SCNNode {
        let cylinderNode = makeCylinderNode(radius: radius, height: height, color: color)
        // x軸を基準に90度(0.5π)回転する
        cylinderNode.simdRotate(
            by: simd_quatf(
                angle: .pi * 0.5, // 回転角
                axis: simd_normalize(simd_float3(1, 0, 0)) // 回転軸
            ),
            aroundTarget: simd_float3(0, 0, 0)
        )
        // 原点まで移動する
        cylinderNode.position = SCNVector3(0, 0, height * 0.5)
        return cylinderNode
    }

    /// シリンダー(円柱)ノードを作成する
    func makeCylinderNode(radius: CGFloat, height: CGFloat, color: UIColor = .white) -> SCNNode {
        let cylinder = SCNCylinder(radius: radius, height: height)
        let node = SCNNode(geometry: cylinder)
        let material = SCNMaterial()
        material.diffuse.contents = color
        node.geometry?.firstMaterial = material
        return node
    }
}
