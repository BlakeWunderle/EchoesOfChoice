using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Fiendling : BaseFighter
    {
        public Fiendling(int level = 15)
        {
            Level = level;
            Health = Stat(180, 210, 6, 10, 15);
            MaxHealth = Health;
            PhysicalAttack = Stat(18, 22, 1, 2, 15);
            PhysicalDefense = Stat(20, 26, 1, 3, 15);
            MagicAttack = Stat(44, 52, 3, 5, 15);
            MagicDefense = Stat(26, 32, 2, 3, 15);
            Speed = Stat(34, 40, 3, 4, 15);
            Abilities = new List<Ability>() { new Brimstone(), new Dread(), new Hex() };
            CharacterType = "Fiendling";
            Mana = Stat(34, 40, 3, 5, 15);
            MaxMana = Mana;
            CritChance = 22;
            CritDamage = 3;
            DodgeChance = 22;
        }

        public Fiendling(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Fiendling(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
