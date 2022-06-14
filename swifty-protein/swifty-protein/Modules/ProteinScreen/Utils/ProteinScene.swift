//
//  ProteinScene.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/14/22.
//

import UIKit
import SceneKit

class ProteinScene: SCNScene, SCNNodeRendererDelegate {
    
    init(proteinData: ProteinData) {
        super.init()
        for element in proteinData.elements {
            let atom = createAtom(
                name: element.name,
                radius: ProteinSizes.Sphere.radius,
                coordinates: element.coordinates
            )
            rootNode.addChildNode(atom)
        }
        let camera = createCamera(elements: proteinData.elements)
        rootNode.addChildNode(camera)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAtom(
        name: String,
        radius: CGFloat,
        coordinates: Coordinates
    ) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.firstMaterial?.diffuse.contents = CPKColors.getColor(string: name)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(coordinates.x, coordinates.y, coordinates.z)
        sphere.name = name
        return sphereNode
    }
    
    private func createCamera(elements: [ElementData]) -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.projectionDirection = .horizontal
        let coordinates = countCameraCoordinates(
            elements: elements,
            cameraAngleDegre: cameraNode.camera!.fieldOfView / 2
        )
        cameraNode.position = SCNVector3(coordinates.x, coordinates.y, coordinates.z)
        cameraNode.camera?.zFar = coordinates.z + ProteinSizes.Camera.farDepthLimitOffsetFromStartHeight
        return cameraNode
    }
    
    private func countCameraCoordinates(elements: [ElementData], cameraAngleDegre: CGFloat) -> Coordinates {
        let extremeCoordinates = moleculeExtremeCoordinates(elements: elements)
        let cathetus = getBiggestDistanceFromCenterToSideOfXYRectangle(extremeCoordinates: extremeCoordinates)
        let zHeight = cathetus / Double(tan(cameraAngleDegre * .pi / 180)) + extremeCoordinates.zMax
        guard zHeight > 10
        else {
            return Coordinates(x: 0, y: 0, z: ProteinSizes.Camera.minStartHeight)
        }
        return Coordinates(x: 0, y: 0, z: zHeight)
    }
    
    private func moleculeExtremeCoordinates(elements: [ElementData]) -> MoleculeExtremeCoordinates {
        var extremeCoordinates = MoleculeExtremeCoordinates()
        for elem in elements {
            extremeCoordinates.xMin = elem.coordinates.x < extremeCoordinates.xMin
                ? elem.coordinates.x
                : extremeCoordinates.xMin
            extremeCoordinates.xMax = elem.coordinates.x > extremeCoordinates.xMax
                ? elem.coordinates.x
                : extremeCoordinates.xMax
            extremeCoordinates.yMin = elem.coordinates.y < extremeCoordinates.yMin
                ? elem.coordinates.y
                : extremeCoordinates.yMin
            extremeCoordinates.yMax = elem.coordinates.y > extremeCoordinates.yMax
                ? elem.coordinates.y
                : extremeCoordinates.yMax
            extremeCoordinates.zMin = elem.coordinates.z < extremeCoordinates.zMin
                ? elem.coordinates.z
                : extremeCoordinates.zMin
            extremeCoordinates.zMax = elem.coordinates.z > extremeCoordinates.zMax
                ? elem.coordinates.z
                : extremeCoordinates.zMax
        }
        return extremeCoordinates
    }
    
    private func getBiggestDistanceFromCenterToSideOfXYRectangle(extremeCoordinates: MoleculeExtremeCoordinates) -> Double {
        let xMax = max(abs(extremeCoordinates.xMax), abs(extremeCoordinates.xMin))
        let yMax = max(abs(extremeCoordinates.yMax), abs(extremeCoordinates.yMin))
        return xMax < yMax
                    ? yMax
                    : xMax
    }
}
