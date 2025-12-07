import { useCurrentAccount, useSignAndExecuteTransaction } from "@iota/dapp-kit";
import { Transaction } from "@iota/iota-sdk/transactions";
import { Button, Container, Flex, Heading, Text, TextArea, TextField } from "@radix-ui/themes";
import { useState } from "react";

interface CreatePropertyProps {
  onCreated: (id: string) => void;
  packageId: string;
}

export function CreateProperty({ onCreated, packageId }: CreatePropertyProps) {
  const currentAccount = useCurrentAccount();
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [location, setLocation] = useState("");
  const [price, setPrice] = useState("");
  const [area, setArea] = useState("");
  const [propertyType, setPropertyType] = useState("1");
  const [imageUrl, setImageUrl] = useState("");

  const handleCreateProperty = () => {
    if (!currentAccount?.address) return;

    const tx = new Transaction();

    tx.moveCall({
      target: `${packageId}::real_estate::create_property`,
      arguments: [
        tx.pure.string(title),
        tx.pure.string(description),
        tx.pure.string(location),
        tx.pure.u64(parseInt(price)),
        tx.pure.u64(parseInt(area)),
        tx.pure.u8(parseInt(propertyType)),
        tx.pure.string(imageUrl),
      ],
    });

    signAndExecute(
      {
        transaction: tx,
      },
      {
        onSuccess: (result) => {
          const objectId = result.digest;
          if (objectId) {
            console.log("Property created:", result);
            // TODO: Parse object ID from result when needed
            onCreated(objectId);
          }
        },
      }
    );
  };

  return (
    <Container>
      <Heading size="4" mb="4">Đăng ký Bất động sản mới</Heading>
      
      <Flex direction="column" gap="3">
        <label>
          <Text size="2" weight="bold">Tiêu đề</Text>
          <TextField.Root
            placeholder="VD: Nhà 3 tầng view biển"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />
        </label>

        <label>
          <Text size="2" weight="bold">Mô tả</Text>
          <TextArea
            placeholder="Mô tả chi tiết về bất động sản..."
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            rows={4}
          />
        </label>

        <label>
          <Text size="2" weight="bold">Địa chỉ</Text>
          <TextField.Root
            placeholder="VD: 123 Trần Hưng Đạo, Đà Nẵng"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
          />
        </label>

        <Flex gap="3">
          <label style={{ flex: 1 }}>
            <Text size="2" weight="bold">Giá (IOTA)</Text>
            <TextField.Root
              type="number"
              placeholder="1000000"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
            />
          </label>

          <label style={{ flex: 1 }}>
            <Text size="2" weight="bold">Diện tích (m²)</Text>
            <TextField.Root
              type="number"
              placeholder="100"
              value={area}
              onChange={(e) => setArea(e.target.value)}
            />
          </label>
        </Flex>

        <label>
          <Text size="2" weight="bold">Loại BĐS</Text>
          <select
            value={propertyType}
            onChange={(e) => setPropertyType(e.target.value)}
            style={{
              width: "100%",
              padding: "8px",
              borderRadius: "4px",
              border: "1px solid var(--gray-a7)",
            }}
          >
            <option value="1">Nhà</option>
            <option value="2">Đất</option>
            <option value="3">Căn hộ</option>
          </select>
        </label>

        <label>
          <Text size="2" weight="bold">URL Hình ảnh</Text>
          <TextField.Root
            placeholder="https://example.com/image.jpg"
            value={imageUrl}
            onChange={(e) => setImageUrl(e.target.value)}
          />
        </label>

        <Button
          size="3"
          onClick={handleCreateProperty}
          disabled={!title || !price || !area}
        >
          Đăng ký BĐS
        </Button>
      </Flex>
    </Container>
  );
}
