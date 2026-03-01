using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class VineWall : Ability
    {
        public VineWall()
        {
            Name = "Vine Wall";
            FlavorText = "Summon a wall of thick vines to shield an ally.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 4;
        }
    }
}
