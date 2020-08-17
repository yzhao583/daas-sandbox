import React, { useState, useEffect, useContext } from 'react';
import { Table, Button, Row, Col, Card, Space } from 'antd';
import NetworkService from "../../services/network";
import { CurrentFileContext } from "../../App";
import "./_data-table.scss";

const DataTable = () => {

    const columns = [
        {
            title: 'File Name',
            dataIndex: 'basename',
        },
        {
            title: 'Last Modified',
            dataIndex: 'lastmod',
        },
        {
            title: '',
            align: 'right',
            render: (text, record) => (
                <Space size="middle">
                    <Button type="primary" onClick={() => setCurrentFile(record)} disabled={currentFileInfo.isEditing}>Open</Button>
                    <Button type="primary" disabled={currentFileInfo.isEditing}>Test</Button>
                    <Button type="primary" disabled={currentFileInfo.isEditing}>Publish</Button>
                </Space>
            ),
        },
    ];
    const [data, setData] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const { currentFileInfo, setCurrentFileInfo } = useContext(CurrentFileContext);
    const webdavClient = NetworkService.connect();

    const setCurrentFile = (record) => {
        if (record) {
            setCurrentFileInfo({ file: record, isEditing: true });
        } else {
            console.error("No file selected when set current file");
        }
    }

    const fetchData = () => {

        setIsLoading(true);

        NetworkService.getFiles(webdavClient).then(response => {
            setData(response);
            setIsLoading(false);
        }, error => {
            console.error(error);
            setIsLoading(false);
        });

    }

    useEffect(() => {
        fetchData();
    }, []);

    return (
        <Card title="DMN Files" className="data-table-container">
            <Row>
                <Col span="24">
                    <Button type="primary" onClick={fetchData} loading={isLoading} disabled={currentFileInfo.isEditing}>
                        Reload
                    </Button>
                </Col>
                <Col span="24">
                    <Table columns={columns} dataSource={data} loading={isLoading}/>
                </Col>
            </Row>
        </Card>
    );
}

export default DataTable;