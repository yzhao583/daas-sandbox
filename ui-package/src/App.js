import React, { useState } from "react";
import { Layout, Row } from "antd";
import "./App.scss";

import DmnModelerComponent from "./components/dmn-modeler/dmn-modeler";
import DataTable from "./components/data-table/data-table";

const { Header, Content, Footer } = Layout;
export const CurrentFileContext = React.createContext(null);

function App() {
  const [currentFileInfo, setCurrentFileInfo] = useState({
    file: {},
    isEditing: false,
  });

  return (
    <CurrentFileContext.Provider
      value={{ currentFileInfo, setCurrentFileInfo }}
    >
      <Layout id="app">
        <Header className="header">
          <div className="logo" />
        </Header>
        <Content className="site-layout">
          <div className="site-layout-background">
            <Row justify="center" align="middle">
              <DmnModelerComponent />
            </Row>
            <Row justify="center" align="middle">
              <DataTable />
            </Row>
          </div>
        </Content>
        <Footer className="footer">Red Hat ©2020 Created by Red Hat</Footer>
      </Layout>
    </CurrentFileContext.Provider>
  );
}

export default App;
