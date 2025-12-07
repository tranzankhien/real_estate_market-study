import { ConnectButton, useCurrentAccount } from "@iota/dapp-kit";
import { Box, Container, Flex, Heading, Tabs } from "@radix-ui/themes";
import { useState } from "react";
import { CreateProperty } from "./CreateProperty";
import { PropertyList } from "./PropertyList";
import { PropertyDetail } from "./PropertyDetail";
import { PACKAGE_IDS } from "./config";

function App() {
  const currentAccount = useCurrentAccount();
  const [selectedPropertyId, setSelectedPropertyId] = useState<string | null>(null);

  return (
    <>
      <Flex
        position="sticky"
        px="4"
        py="2"
        justify="between"
        style={{
          borderBottom: "1px solid var(--gray-a2)",
          background: "var(--accent-9)",
        }}
      >
        <Box>
          <Heading style={{ color: "white" }}>🏠 Sàn Giao Dịch Bất Động Sản</Heading>
        </Box>

        <Box>
          <ConnectButton />
        </Box>
      </Flex>
      <Container>
        <Container
          mt="5"
          pt="2"
          px="4"
          style={{ background: "var(--gray-a2)", minHeight: 500 }}
        >
          {currentAccount ? (
            selectedPropertyId ? (
              <PropertyDetail
                propertyId={selectedPropertyId}
                onBack={() => setSelectedPropertyId(null)}
              />
            ) : (
              <Tabs.Root defaultValue="list">
                <Tabs.List>
                  <Tabs.Trigger value="list">📋 Danh sách BĐS</Tabs.Trigger>
                  <Tabs.Trigger value="create">➕ Đăng ký BĐS</Tabs.Trigger>
                </Tabs.List>

                <Box pt="4">
                  <Tabs.Content value="list">
                    <PropertyList onSelectProperty={setSelectedPropertyId} />
                  </Tabs.Content>

                  <Tabs.Content value="create">
                    <CreateProperty
                      packageId={PACKAGE_IDS.PROPERTY}
                      onCreated={(id) => {
                        setSelectedPropertyId(id);
                      }}
                    />
                  </Tabs.Content>
                </Box>
              </Tabs.Root>
            )
          ) : (
            <Flex
              direction="column"
              align="center"
              justify="center"
              gap="4"
              style={{ minHeight: "400px" }}
            >
              <Heading size="6">🔐 Vui lòng kết nối ví</Heading>
              <Heading size="3" color="gray">
                Để sử dụng sàn giao dịch bất động sản
              </Heading>
            </Flex>
          )}
        </Container>
      </Container>
    </>
  );
}

export default App;
