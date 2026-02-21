using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Sprite : BaseFighter
    {
        public Sprite(int level = 4)
        {
            Level = level;
            Health = Stat(49, 68, 4, 8, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(16, 24, 2, 4, 4);
            PhysicalDefense = Stat(8, 15, 1, 3, 4);
            MagicAttack = Stat(8, 15, 1, 3, 4);
            MagicDefense = Stat(9, 16, 1, 3, 4);
            Speed = Stat(21, 32, 2, 5, 4);
            Abilities = new List<Ability>() { new Thorn(), new Pollen() };
            CharacterType = "Sprite";
            Mana = Stat(21, 37, 2, 5, 4);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 1;
            DodgeChance = 3;
        }

        public Sprite(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Sprite(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(4, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
