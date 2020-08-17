import React, { useEffect, useState, useContext } from 'react';
import DmnModeler from 'dmn-js/lib/Modeler';
import { Empty, Button, Card } from 'antd';
import NetworkService from "../../services/network";
import { CurrentFileContext } from "../../App";
import './_dmn-modeler.scss';

const DmnModelerComponent = () => {

    const [dmnModeler, setDmnModeler] = useState();
    const [isLoading, setIsLoading] = useState(false);
    const { currentFileInfo, setCurrentFileInfo } = useContext(CurrentFileContext);
    const webdavClient = NetworkService.connect();

    useEffect(() => {

        if (currentFileInfo.file.filename) {
            setIsLoading(true);
            NetworkService.getFile(webdavClient, currentFileInfo.file.filename).then(fileData => {
                setIsLoading(false);
                const dmnModelerInstance = new DmnModeler({
                    container: '.editor-container',
                    height: 600,
                    width: '100%',
                    keyboard: {
                        bindTo: window
                    }
                });

                dmnModelerInstance.importXML(fileData, function (err) {

                    if (err) {
                        return console.error('could not import DMN 1.1 diagram', err);
                    }

                    let activeEditor = dmnModelerInstance.getActiveViewer();

                    // access active editor components
                    let canvas = activeEditor.get('canvas');

                    // zoom to fit full viewport
                    canvas.zoom('fit-viewport');
                });

                setDmnModeler(dmnModelerInstance);
            }, error => {
                console.error(error);
                setIsLoading(false);
            });
        } else {
            console.log("No dmn file found");
            setIsLoading(false);
        }

    }, [currentFileInfo]);

    /**
    * Save file contents to remote server.
    */
    const saveFile = () => {

        setIsLoading(true);

        dmnModeler.saveXML({ format: true }, function (err, xml) {

            if (err) {
                setIsLoading(false);
                return console.error('could not save DMN diagram', err);
            }

            NetworkService.updateFile(webdavClient, currentFileInfo.file.filename, xml).then(response => {
                setCurrentFileInfo({ file: {}, isEditing: false });
                setIsLoading(false);
            }, error => {
                console.error(error);
                setIsLoading(false);
            });
        });
    }

    return (
        <Card title="DMN Modeler" className="dmn-modeler-container" loading={isLoading}>
            {
                currentFileInfo.file.filename
                    ?
                    <div className="editor-parent">
                        <div className="editor-container"></div>
                        <Button id="save-button" type="primary" onClick={saveFile}>Save</Button>
                    </div>
                    :
                    <Empty description={"Please select one DMN file from the table below to view and edit it here."} />
            }

        </Card>
    )
}

export default DmnModelerComponent;

