using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Seraph : BaseFighter
    {
        public Seraph(int level = 9)
        {
            Level = level;
            Health = Stat(136, 164, 8, 14, 9);
            MaxHealth = Health;
            PhysicalAttack = Stat(36, 46, 3, 6, 9);
            PhysicalDefense = Stat(30, 38, 3, 5, 9);
            MagicAttack = Stat(37, 47, 3, 6, 9);
            MagicDefense = Stat(28, 36, 3, 5, 9);
            Speed = Stat(24, 32, 2, 4, 9);
            Abilities = new List<Ability>() { new Judgment(), new Sanctuary(), new Consecrate() };
            CharacterType = "Seraph";
            Mana = Stat(50, 65, 3, 6, 9);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Seraph(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Seraph(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
