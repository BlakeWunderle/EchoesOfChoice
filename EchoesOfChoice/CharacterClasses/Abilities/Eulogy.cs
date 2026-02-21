using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Eulogy : Ability
    {
        public Eulogy()
        {
            Name = "Eulogy";
            FlavorText = "Words pierce the enemy's mental armor.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
