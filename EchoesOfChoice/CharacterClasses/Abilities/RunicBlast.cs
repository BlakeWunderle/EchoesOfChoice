using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class RunicBlast : Ability
    {
        public RunicBlast()
        {
            Name = "Runic Blast";
            FlavorText = "Unleash a concentrated burst of runic energy at your foe.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 9;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
